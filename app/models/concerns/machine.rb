module Machine
  extend ActiveSupport::Concern
  included do
    attr_accessor  :price, :capacity, :period, :end_time
    has_one :load, as: :machine
    belongs_to :user
    after_save :set_name, on: [:create, :new]
    after_initialize  :set_instance_attributes
    
    scope :available_machines, -> {where(state: "available")}
    scope :completed_machines, -> {where(state: "complete")}
    scope :unavailable_machines, -> {where.not(state: "available")}
    
    include Workflow
    acts_as_list
    workflow_column :state
    workflow do
      state :available do
        event :claim, :transitions_to => :empty
      end
      state :empty do
        event :fill, :transitions_to => :ready, :if => proc {|machine| machine.enough_coins?}
        event :fill, :transitions_to => :unpaid
        event :return_coins, :transitions_to => :empty, :if => proc {|machine| machine.coins != 0 }

        event :unclaim, :transitions_to => :available
      end
      state :unpaid do
        # event :insert_coins, :transitions_to => :unpaid
        # event :insert_coins, :transitions_to => :unpaid, :if => proc {|machine| !machine.enough_coins?}
        event :insert_coins, :transitions_to => :ready
        event :remove_clothes, :transitions_to => :empty
      end
      state :ready do
        event :return_coins, :transitions_to => :unpaid, :if => proc {|machine| machine.coins > 0 }
        event :start, :transitions_to => :in_progess, :if => proc {|machine| machine.enough_coins?}
        event :remove_clothes, :transitions_to => :empty
      end
      state :in_progess do
        event :end_cycle, :transitions_to => :complete
      end
      state :complete do
        event :remove_clothes, :transitions_to => :empty
      end
    end
  end
  def enough_coins?
    self.coins >= self.price
  end
  def claim(user=nil)
    update(user: user)
    # update_attribute(:user, user)
  end
  def unclaim
    update(user: nil)
    # update_attribute(:user, nil)
  end
  def fill(load=nil)
    # puts self.methods.sort
    # puts "capacity#{self.capacity}"
    # puts self.inspect
    if !load
      raise "Cannot insert an empty load"
    elsif load.weight <= @capacity
      self.update(load: load)
      reduce_capacity(load.weight)
    else
      raise "Cannot insert a load heavier than capacity"
    end
    # unless load.weight <= capacity
  end
  def return_coins
    self.reset_coins

  end
  def reduce_capacity(weight=0)
    @capacity -= weight
  end
  def reduce_price
    @price -= @coins
  end
  def next_steps
    current_state.events.collect { |event, val|  event.id2name}
  end
  def insert_coins(count=0)
    # increment!(:coins, count.to_i)
    # halt! "machine cannot start until more coins are inserted, currently has #{self.coins}" unless enough_coins?
    begin
      increment!(:coins, count.to_i)
      halt! "machine cannot start until more coins are inserted, currently has #{self.coins}" unless enough_coins?
    rescue Workflow::TransitionHalted => e
      errors.add(:coins, e)
      puts self.errors.inspect
    end
  end
  def reset_coins
    self.update(coins: 0)
  end
  def start
    @end_time = Time.now + self.period
    end_cycle if Time.now > self.end_time
  end
  def end_cycle
    self.reset_coins
  end
  def remove_clothes
  end
  def time_remaining
    if self.state == "in_progress"
      (Time.now - self.end_time).to_s
    else
      return @period
    end
  end
  def capacity
    raise "Subclass responsibility"
  end
  def period
    raise "Subclass responsibility"
  end
  def price
    raise "Subclass responsibility"
  end
  def set_instance_attributes
    # @coins ||= 0
  end
end
