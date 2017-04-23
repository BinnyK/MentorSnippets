json.extract! tweet, :id, :t_id_str, :t_text, :t_created_at, :t_user_id_str, :t_screen_name, :question_id, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
