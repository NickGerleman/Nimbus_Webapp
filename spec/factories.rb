FactoryGirl.define do
  factory :user do
    name 'Bob'
    email 'name@example.com'
    email_confirmation 'name@example.com'
    password 'password'
    password_confirmation 'password'
  end
end