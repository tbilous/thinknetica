class AddForeignKeyToAnswers < ActiveRecord::Migration
  def change
    add_foreign_key :answers, :users
  end
end
