class Washer < ActiveRecord::Base
  validates_presence_of :type
  skip_callback :initialize, :after, :set_name, :set_instance_attributes, if: -> { self.class.name == "Washer"}

  include Machine


  def insert_coins(count=0)
    iCount = count.to_i
    coin_diff = price - coins
    begin
      halt! "machine currently has #{coins}, cannot insert more than #{coin_diff} coins " if coin_excess?(count)
    rescue Workflow::TransitionHalted => e
      errors.add(:coins, e)
    else
      super
    end
  end

  def start
    super
    load.wash!
  end
  def coin_excess?(newCoin=0)
    return coins + newCoin.to_i > price
  end
  private
  def set_name
  end
  def set_instance_attributes
    super
  end
end
