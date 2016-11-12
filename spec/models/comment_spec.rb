# string   "commentable_type"
# integer  "commentable_id"
# integer  "user_id"
# string   "body"
# datetime "created_at

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }
end
