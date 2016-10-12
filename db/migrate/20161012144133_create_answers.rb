class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id

      t.text :body

      t.timestamps null: false
    end
    add_foreign_key :answers, :questions
    add_index :answers, [:question_id, :created_at]
  end
end
