# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development?
  Washer.delete_all
  Dryer.delete_all
  10.times do |i|
    Washer.create( type: "SWasher")
    Washer.create( type: "MWasher")
    Washer.create( type: "LWasher")
    Washer.create( type: "XlWasher")
    Dryer.create()

  end

end
