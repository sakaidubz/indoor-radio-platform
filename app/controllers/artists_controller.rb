class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :edit, :update, :destroy]

  def index
    @artists = Artist.order(created_at: :desc)
  end

  def show; end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      redirect_to @artist, notice: 'Artist created.'
    else
      flash.now[:alert] = @artist.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @artist.update(artist_params)
      redirect_to @artist, notice: 'Artist updated.'
    else
      flash.now[:alert] = @artist.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @artist.destroy
    redirect_to artists_path, notice: 'Artist deleted.'
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :genre, :theme_color, :bio, :photo_url, :logo_url, :x_id, :instagram_id, :soundcloud_id, :other_links, :status)
  end
end

