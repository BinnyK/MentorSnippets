class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.string :t_id_str
      t.string :t_text
      t.string :t_created_at
      t.string :t_user_id_str
      t.string :t_screen_name
      t.integer :question_id

      t.timestamps
    end
  end
end
