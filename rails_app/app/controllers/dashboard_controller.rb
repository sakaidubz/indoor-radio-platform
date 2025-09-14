class DashboardController < ApplicationController
  def index
    @artists_count = Artist.count
    @episodes_count = Episode.count
    @posts_count = SocialPost.count
  end
end

