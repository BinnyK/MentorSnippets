json.extract! question, :id, :title, :hashtag, :is_answered, :created_at, :updated_at
json.url question_url(question, format: :json)
