require "faker"

FactoryGirl.define do
  factory :load do
    weight {Faker::Number.between(from = 1, to = 9)}
    state nil
    position 1
    association :user
    machine nil
  end
end
