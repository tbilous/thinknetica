FactoryGirl.define do
  answer_body = 'b' * 61
  factory :answer do
    question
    body answer_body
  end
  factory :wrong_answer, class: 'Answer' do
    question
    body nil
  end
end
