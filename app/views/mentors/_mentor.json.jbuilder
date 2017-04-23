json.extract! mentor, :id, :twitter_id_str, :name, :screen_name, :description, :url, :followers_count, :friends_count, :profile_background_color, :profile_background_image_url, :profile_banner_url, :profile_image_url, :created_at, :updated_at
json.url mentor_url(mentor, format: :json)
