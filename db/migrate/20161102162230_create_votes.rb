class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references  :votesable, polymorphic: true, index: true
      t.references :user, foreign_key: true
      t.integer     :challenge

      t.timestamps null: false
    end
  end
end
