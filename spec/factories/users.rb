require 'faker'

FactoryGirl.define do
  factory :user do
    admin false
    guest false
    email {Faker::Internet.email}
    username {Faker::Internet.user_name}
    password {Faker::Internet.password}
    coins {Faker::Number.between(from = 12, to = 32)}
    laundry {Faker::Number.between(from = 4, to = 30)}


    factory :admin do
      admin true
    end
  end
end
