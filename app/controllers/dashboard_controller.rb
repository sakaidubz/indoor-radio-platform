class DashboardController < ApplicationController
  def index
    @artists_count = Artist.count
    @episodes_count = Episode.count
    @posts_count = SocialPost.count

    @recent_artists = Artist.order(created_at: :desc).limit(5)
    @recent_episodes = Episode.order(created_at: :desc).limit(5)
    @recent_posts = SocialPost.order(created_at: :desc).limit(5)

    @upcoming_episodes = Episode
      .where("scheduled_date IS NOT NULL AND scheduled_date >= ?", Time.current)
      .order(:scheduled_date)
      .limit(5)

    @episodes_by_status = Episode.group(:status).count
    @posts_by_status = SocialPost.group(:status).count
  end
end
