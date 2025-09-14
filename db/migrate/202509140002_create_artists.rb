class CreateArtists < ActiveRecord::Migration[7.1]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.string :genre
      t.string :theme_color
      t.text :bio
      t.string :photo_url
      t.string :logo_url
      t.string :x_id
      t.string :instagram_id
      t.string :soundcloud_id
      t.text :other_links
      t.string :status, default: 'draft'
      t.timestamps
    end
  end
end

