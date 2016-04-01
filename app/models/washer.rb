# washes the load of the claiming user
class Washer < ActiveRecord::Base
  # validations
  validates_presence_of :type
  # callbacks
  #  since this is the superclass of the STI model
  #  initialize callbacks are skipped
  skip_callback :initialize, :after, :set_name, :set_instance_attributes, if: -> { self.class.name == "Washer"}

  include Machine

  # inserts a number of coins into the machine
  # if inserted coins are not exact, an error is raised
  # @param [Fixnum] count = 0
  def insert_coins(count = 0)
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

  # starts cycle and washes load
  def start
    super
    load.wash!
  end

  # checks if inserted coins number
  # more than washer price
  # @param [Fixnum] newCoin = 0
  def coin_excess?(newCoin = 0)
    coins + newCoin.to_i > price
  end

  private

  # not implemented in this class
  def set_name
  end

  # not implemented in this class
  def set_instance_attributes
    super
  end
end
