FactoryGirl.define do
  factory :vote do
    votesable { |v| v.association(:question) }
    user
    challenge 1
  end
end
