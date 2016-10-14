FactoryGirl.define do
  answer_title = 'a' * 5
  answer_body = 'a' * 61
  factory :question do
    title answer_title
    body  answer_body
  end
  factory :wrong_question, class: 'Question' do
    title nil
    body  nil
  end
end
