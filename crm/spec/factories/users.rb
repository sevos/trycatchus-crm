FactoryGirl.define do
  factory :user do
    name
    password 'qwerty'
    password_confirmation 'qwerty'
    type "User"
  end
end
