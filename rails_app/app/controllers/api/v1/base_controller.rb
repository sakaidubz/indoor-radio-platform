module Api
  module V1
    class BaseController < ActionController::API
      before_action :authorize_request!

      private

      def jwt_secret
        ENV.fetch('JWT_SECRET', 'your-secret-key')
      end

      def authorize_request!
        header = request.headers['Authorization']
        return render json: { error: 'Authorization header required' }, status: :unauthorized if header.blank?

        type, token = header.split(' ', 2)
        return render json: { error: 'Invalid authorization header format' }, status: :unauthorized unless type == 'Bearer' && token.present?

        begin
          decoded = JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' })
          payload = decoded.first
          @current_user_id = payload['user_id']
          @current_username = payload['username']
          @current_role = payload['role']
        rescue JWT::DecodeError
          render json: { error: 'Invalid or expired token' }, status: :unauthorized
        end
      end

      def require_role!(*roles)
        return if roles.include?(@current_role)
        render json: { error: 'Insufficient permissions' }, status: :forbidden
      end
    end
  end
end

