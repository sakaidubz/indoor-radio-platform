class CreateSocialPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :social_posts do |t|
      t.references :episode, null: false, foreign_key: true
      t.string :platform, null: false
      t.text :content, null: false
      t.datetime :scheduled_at
      t.datetime :posted_at
      t.string :post_id
      t.string :status, default: 'scheduled'
      t.timestamps
    end
  end
end

