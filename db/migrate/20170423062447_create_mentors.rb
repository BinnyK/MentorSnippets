class CreateMentors < ActiveRecord::Migration[5.0]
  def change
    create_table :mentors do |t|
      t.string :twitter_id_str
      t.string :name
      t.string :screen_name
      t.text :description
      t.string :url
      t.integer :followers_count, default: 0
      t.integer :friends_count, default: 0
      t.string :profile_background_color
      t.string :profile_background_image_url
      t.string :profile_banner_url
      t.string :profile_image_url

      t.timestamps
    end
  end
end
