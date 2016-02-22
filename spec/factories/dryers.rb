require "faker"

FactoryGirl.define do
  factory :dryer do
    name {Faker::Lorem.words(1)}
    position 1
    user nil
  end


end
