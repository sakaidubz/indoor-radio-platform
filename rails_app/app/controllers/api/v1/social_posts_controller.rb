module Api
  module V1
    class SocialPostsController < Api::V1::BaseController
      def index
        render json: SocialPost.all
      end

      def create
        p = SocialPost.new(post_params)
        if p.save
          render json: p, status: :created
        else
          render json: { error: p.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def schedule
        p = SocialPost.find(params[:id])
        p.scheduled_at ||= Time.current
        if p.update(status: 'scheduled')
          render json: p
        else
          render json: { error: p.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.permit(:episode_id, :platform, :content, :scheduled_at, :posted_at, :post_id, :status)
      end
    end
  end
end

