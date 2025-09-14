module Api
  module V1
    class AuthController < ActionController::API
      def login
        username = params.require(:username)
        password = params.require(:password)
        user = User.find_by(username: username)
        return render json: { error: 'Invalid credentials' }, status: :unauthorized unless user&.authenticate(password)

        token = generate_token(user)
        render json: { token: token, user: user.as_json(except: [:password_digest]) }
      end

      def register
        permitted = params.permit(:username, :email, :password, :role)
        permitted[:role] ||= 'editor'
        user = User.new(permitted)
        if user.save
          token = generate_token(user)
          render json: { token: token, user: user.as_json(except: [:password_digest]) }, status: :created
        else
          render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def logout
        render json: { message: 'Logged out successfully' }
      end

      def profile
        user = current_user
        return render json: { error: 'User not found' }, status: :not_found unless user
        render json: { user: user.as_json(except: [:password_digest]) }
      end

      def update_profile
        user = current_user
        return render json: { error: 'User not found' }, status: :not_found unless user
        permitted = params.permit(:username, :email)
        if user.update(permitted)
          render json: { user: user.as_json(except: [:password_digest]) }
        else
          render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def change_password
        user = current_user
        return render json: { error: 'User not found' }, status: :not_found unless user
        current_password = params.require(:current_password)
        new_password = params.require(:new_password)
        unless user.authenticate(current_password)
          return render json: { error: 'Current password is incorrect' }, status: :unauthorized
        end
        if user.update(password: new_password)
          render json: { message: 'Password updated successfully' }
        else
          render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      private

      def jwt_secret
        ENV.fetch('JWT_SECRET', 'your-secret-key')
      end

      def generate_token(user)
        payload = {
          user_id: user.id,
          username: user.username,
          role: user.role,
          exp: 24.hours.from_now.to_i
        }
        JWT.encode(payload, jwt_secret, 'HS256')
      end

      def current_user
        header = request.headers['Authorization']
        return nil if header.blank?
        type, token = header.split(' ', 2)
        return nil unless type == 'Bearer' && token.present?
        decoded = JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' })
        id = decoded.first['user_id']
        User.find_by(id: id)
      rescue JWT::DecodeError
        nil
      end
    end
  end
end

