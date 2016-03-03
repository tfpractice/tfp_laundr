require 'faker'

FactoryGirl.define do
  factory :washer do
    name {Faker::Lorem.words(1)}
    position 1
    type "MWasher"
    # association :user
  end
end
