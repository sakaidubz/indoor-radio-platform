module Api
  module V1
    class ArtistsController < Api::V1::BaseController
      def index
        render json: Artist.all
      end

      def show
        render json: artist
      end

      def create
        a = Artist.new(artist_params)
        if a.save
          render json: a, status: :created
        else
          render json: { error: a.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def update
        if artist.update(artist_params)
          render json: artist
        else
          render json: { error: artist.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def destroy
        artist.destroy
        head :no_content
      end

      private

      def artist
        @artist ||= Artist.find(params[:id])
      end

      def artist_params
        params.permit(:name, :genre, :theme_color, :bio, :photo_url, :logo_url, :x_id, :instagram_id, :soundcloud_id, :other_links, :status)
      end
    end
  end
end

