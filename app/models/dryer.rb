class Dryer < ActiveRecord::Base
  include Machine
  belongs_to :user

   def price
    3.00
  end
  def capacity
    15.0
  end
  def period
    30.0
  end
end
