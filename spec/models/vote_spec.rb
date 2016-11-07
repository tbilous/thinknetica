require 'rails_helper'

# t.integer  "votesable_id"
# t.string   "votesable_type"
# t.integer  "user_id"
# t.integer  "challenge"
# t.datetime "created_at",     null: false
# t.datetime "updated_at",     null: false

RSpec.describe Vote, type: :model do
  it { should belong_to :votesable }
  it { should belong_to :user }
  it do
    subject.user = build(:user)
    should validate_uniqueness_of(:user_id).scoped_to([:votesable_type, :votesable_id])
  end
end
