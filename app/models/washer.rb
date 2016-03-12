class Washer < ActiveRecord::Base
  validates_presence_of :type
  skip_callback :initialize, :after, :set_name, :set_instance_attributes, if: -> { self.class.name == "Washer"}
  # validate :coin_excess?, on: [:insert_coins]



  include Machine
  def insert_coins(count=0)
    iCount = count.to_i

    if self.coins + iCount > @price
      raise "Cannot supply more than #{@price} coins"
    else
      super
    end

  end

  def coin_excess?(newCoin=0)
    # if coins + newCoin.to_i > price
      # coin_diff = price - coins
      # errors.add(:coins, "machine currently has #{coins}, cannot insert more than #{coin_diff} coins ")
    # end
    return coins + newCoin.to_i > price
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
