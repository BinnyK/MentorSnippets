class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :title
      t.string :hashtag
      t.boolean :is_answered, default: false

      t.timestamps
    end
  end
end
