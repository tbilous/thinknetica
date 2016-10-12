FactoryGirl.define do
  answer_body = 'a' * 61
  factory :answer do
    body answer_body
  end
end
