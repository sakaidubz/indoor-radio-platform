module Api
  module V1
    class EpisodesController < Api::V1::BaseController
      def index
        render json: Episode.all
      end

      def show
        render json: episode
      end

      def create
        e = Episode.new(episode_params)
        if e.save
          render json: e, status: :created
        else
          render json: { error: e.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def update
        if episode.update(episode_params)
          render json: episode
        else
          render json: { error: episode.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def destroy
        episode.destroy
        head :no_content
      end

      private

      def episode
        @episode ||= Episode.find(params[:id])
      end

      def episode_params
        params.permit(:artist_id, :title, :scheduled_date, :soundcloud_url, :artwork_url, :status)
      end
    end
  end
end

