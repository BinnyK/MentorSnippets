class AddFieldsToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :t_user_prof_img_url, :string
    add_column :tweets, :t_user_prof_bg_col, :string
    add_column :tweets, :t_favorite_count, :integer, default: 0
  end
end
