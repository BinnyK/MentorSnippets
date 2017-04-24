class AddBannerToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :t_user_prof_ban_url, :string
  end
end
