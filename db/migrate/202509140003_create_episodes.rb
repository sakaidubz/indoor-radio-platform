class CreateEpisodes < ActiveRecord::Migration[7.1]
  def change
    create_table :episodes do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :title, null: false
      t.datetime :scheduled_date
      t.string :soundcloud_url
      t.string :artwork_url
      t.string :status, default: 'planning'
      t.timestamps
    end
  end
end

