class Washer < ActiveRecord::Base
  belongs_to :user

  def capacity
    raise "Subclass responsibility"
  end
  def period
    raise "Subclass responsibility"
  end
  def price
    raise "Subclass responsibility"
  end
end
