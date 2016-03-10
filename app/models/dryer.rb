class Dryer < ActiveRecord::Base
  # belongs_to :user
  include Machine


  # self.states[:ready].events.push(event :insert_coins, :transitions_to => :ready)
  # workflow do
  #   state :available do
  #     event :claim, :transitions_to => :empty
  #   end
  #   state :empty do
  #     event :fill, :transitions_to => :unpaid
  #     event :unclaim, :transitions_to => :available
  #   end
  #   state :unpaid do
  #     event :insert_coins, :transitions_to => :ready
  #     event :remove_clothes, :transitions_to => :empty
  #   end
  #   state :ready do
  #     event :insert_coins, :transitions_to => :ready
  #     event :start, :transitions_to => :in_progess
  #     event :remove_clothes, :transitions_to => :empty
  #   end
  #   state :in_progess do
  #     event :insert_coins, :transitions_to => :in_progess
  #     event :end_cycle, :transitions_to => :complete
  #   end
  #   state :complete do
  #     event :insert_coins, :transitions_to => :ready
  #     event :remove_clothes, :transitions_to => :empty
  #   end
  # end

  def insert_coins(count=0)
    super
    self.period += (5*count.to_i)
  end
  private
  def set_name
    self.update(name: "Dryer ##{self.id}" )  unless self.name
  end
  def set_instance_attributes
    @price ||= 1
    @capacity ||= 15.0
    @period ||=  5 * self.coins
  end
end
