class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show, :edit, :update, :destroy]

  def index
    @episodes = Episode.includes(:artist).order(created_at: :desc)
  end

  def show; end

  def new
    @episode = Episode.new
  end

  def create
    @episode = Episode.new(episode_params)
    if @episode.save
      redirect_to @episode, notice: 'Episode created.'
    else
      flash.now[:alert] = @episode.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @episode.update(episode_params)
      redirect_to @episode, notice: 'Episode updated.'
    else
      flash.now[:alert] = @episode.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @episode.destroy
    redirect_to episodes_path, notice: 'Episode deleted.'
  end

  private

  def set_episode
    @episode = Episode.find(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:artist_id, :title, :scheduled_date, :soundcloud_url, :artwork_url, :status)
  end
end

