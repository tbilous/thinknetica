FactoryGirl.define do
  sequence :email do |n|
    "privat#{n}@example.com"
  end
  name = 'Taras Bilous'
  password = 'foobar'

  factory :user do
    name name
    email
    password password
    password_confirmation password
    confirmed_at Time.now
  end
end
