require 'faker'

FactoryGirl.define do
  factory :user do
    admin false
    guest false
    email {Faker::Internet.email}
    username {Faker::Internet.user_name}
    password {Faker::Internet.password}
    
    factory :admin do
      admin true
    end
  end
end
