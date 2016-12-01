class UpdateForeignKey < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :authorizations, :users
    add_foreign_key :authorizations, :users, on_delete: :cascade
  end
end
