class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean     :vote
      t.references  :votesable, polymorphic: true, index: true
      t.references  :user, index: true

      t.timestamps null: false
    end
  end
end
