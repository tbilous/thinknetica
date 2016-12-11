FactoryGirl.define do
  factory :answer do
    question
    body Faker::StarWars.quote
    best false
  end
  factory :wrong_answer, class: Answer do
    body nil
  end
end
