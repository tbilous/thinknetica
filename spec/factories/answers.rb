FactoryGirl.define do
  answer_body = 'b' * 61
  factory :answer do
    question
    body answer_body
    best false
  end
  factory :wrong_answer, class: Answer do
    body nil
  end
end
