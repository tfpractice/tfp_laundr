class Washer < ActiveRecord::Base
  validates_presence_of :type
  skip_callback :initialize, :after, :set_name, :set_instance_attributes, if: -> { self.class.name == "Washer"}




  include Machine
  def insert_coins(count=0)
    iCount = count.to_i

    if self.coins + iCount > @price
      raise "Cannot supply more than #{@price} coins"
    else
      super
    end

  end
  private

  def set_name
    #   self.name ||= "Washer_#{self.id}"
  end
  def set_instance_attributes
    super
    # puts @coins
  end
end
