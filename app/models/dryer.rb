class Dryer < ActiveRecord::Base
  belongs_to :user

  include Machine
  def initialize(attributes={})
    super()
    # @coins ||= 0
    @price =  3
    @capacity = 15.0
    @period = 5 * @coins
  end
 
  # def insert_coins(count=0)
  #   @coins += count

  # end
end
