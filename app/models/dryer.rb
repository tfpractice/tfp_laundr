class Dryer < ActiveRecord::Base
  # belongs_to :user


  include Machine
  # def initialize(attributes={})
  #   super()
  #   # @coins ||= 0
  #   @price =  1
  #   @capacity = 15.0
  #   @period = 5 * @coins
  # end
  def insert_coins(count=0)
    # puts "pre call dryer.coins #{coins}"
    # puts "pre call dryerinstance.coins #{@coins}"

    super
    # puts "post call dryer.coins #{coins}"
    # puts "post call dryerinstance.coins #{@coins}"


    @period += (5*count.to_i)

  end



  private
  def set_name
    self.update(name: "Dryer ##{self.id}" )  unless self.name
  end
  def set_instance_attributes
    @price ||= 1
    @capacity ||= 15.0
    @period ||=  5 * @coins
  end
end
