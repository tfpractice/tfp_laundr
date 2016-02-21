require 'faker'

FactoryGirl.define do
  factory :washer do
    name {Faker::Lorem.words(1)}
    position 1
    state nil
    type ""
    association :user
  end
end
