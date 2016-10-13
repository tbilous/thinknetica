class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :question, index: true, foreign_key: true
      t.text :body

      t.timestamps null: false
    end
    add_index :answers, :created_at
  end
end
