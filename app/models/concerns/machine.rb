# Provides the general functionality of both Washers and Dryers.
# most of the methods here are implementations
# of the Workflow gem's state-machine behavior
module Machine
  extend ActiveSupport::Concern

  included do

    attr_accessor  :price, :capacity, :period, :end_time

    # AR relationships
    has_one :load, as: :machine
    belongs_to :user

    # AR callbacks
    after_save :set_name, on: [:create, :new]
    after_initialize :set_instance_attributes

    # named scopes for relationships
    scope :available_machines, -> { where(state: 'available') }
    scope :affordable_machines, ->(user) { where(id: all.select { |machine| machine.price <= user.coins }.map(&:id)) }
    scope :completed_machines, -> { where(state: 'complete') }
    scope :unavailable_machines, -> { where.not(state: 'available') }
    scope :can_accept_load, ->(load) { where("capacity >= ?", load.weight) }

    include Workflow
    # acts as list functionality
    acts_as_list
    # sets workflow column to :state
    workflow_column :state
    # avaialble states, transitions, and events
    workflow do
      # default state is available
      state :available do
        event :claim, transitions_to: :empty
      end
      state :empty do
        event :unclaim, transitions_to: :available
        event :return_coins, transitions_to: :empty, if: -> (machine) { machine.coins > 0 }
        event :fill, transitions_to: :ready, if: -> (machine) { machine.enough_coins? }
        event :fill, transitions_to: :unpaid
      end
      state :unpaid do
        event :insert_coins, transitions_to: :ready
        event :return_coins, transitions_to: :unpaid, if: -> (machine) { machine.coins > 0 }
        event :remove_clothes, transitions_to: :empty, if: -> (machine) { machine.load != nil }
      end
      state :ready do
        event :return_coins, transitions_to: :unpaid, if: -> (machine) { machine.coins > 0 }
        event :start, transitions_to: :in_progress, if: -> (machine) { machine.enough_coins? }
        event :remove_clothes, transitions_to: :empty, if: -> (machine) { machine.load != nil }
      end
      state :in_progress do
        event :end_cycle, transitions_to: :complete
      end
      state :complete do
        event :remove_clothes, transitions_to: :empty, if: -> (machine) { machine.load != nil }
      end
    end
  end

  # upon changing @state from :ready to :in_progress
  # begins a new thread that sleeps for @period
  # and calls :end_cycle!
  def on_in_progress_entry(new_state, event, *args)
    # Runs a thread that sleeps for !@period
    thr = Thread.new do
      sleep period
      end_cycle!
    end
  end

  # transitions_to => :empty
  # sets machine user
  # @param [User] user
  def claim(user=nil)
    update(user: user)
  end

  # sets user to nil
  # state tranistion to available
  def unclaim
    update(user: nil)
  end

  # sets the machines load attribute
  # @param [Load] load
  # if load is nil or is heavier than
  # machine capacity, and error is raised
  def fill(load=nil)
    begin
      halt! "Cannot insert an empty load" unless load
      halt! "Cannot insert a load heavier than capacity" unless load.weight <= @capacity
    rescue Workflow::TransitionHalted => e
      errors.add(:load, e)
    else
      self.update(load: load)
      load.insert!(self)
    end
  end

  # returns the current number of coins to user
  # sets coins to 0
  def return_coins
    user.increase_coins(coins)
    self.reset_coins
  end

  # returns a list of available
  # Workflow event names
  # @return [Array] valid_events
  def next_steps
    valid_events = []
    current_state.events.each do |event, val|
      if (val.any? { |v| v.condition == nil })
        valid_events << event.id2name
      elsif (val.any? { |v| v.condition != nil })
        valid_conditional_events = val.select { |v| v.condition }.select { |e| e.condition.call(self) == true }
        valid_conditional_events.each { |e| valid_events << event.id2name  }
      end
    end
    valid_events
  end

  # increments the machines coins by count
  # if after increment, the machine's coins
  # match the machine price,
  # the state is chnaged to ready
  # otherwise, the state doesnt change
  # @param [Fixnum] count
  def insert_coins(count=0)
    begin
      user.reduce_coins(count.to_i)
      increment!(:coins, count.to_i)
      halt! "machine cannot start until #{self.price} coins are inserted. currently has #{self.coins}" unless enough_coins?
    rescue Workflow::TransitionHalted => e
      errors.add(:coins, e)
    end
  end

  # if there is a load in the machine
  # hard_reset is called on the load
  # then the object is updated with defaults
  def hard_reset
    load.hard_reset unless !load
    self.update(coins: 0, load: nil, user: nil, state: "available")
  end

  # checks if the machine's coins
  # are greater than or equal to its price
  # @return [Boolean]
  def enough_coins?
    self.coins >= self.price
  end

  # sets machine coins to 0
  def reset_coins
    self.update(coins: 0)
  end

  # sets end_time and begins
  # transition to in_progress
  def start
    @end_time = Time.now + self.period
  end

  # ends current cycle and resets coins
  def end_cycle
    self.reset_coins
  end

  # removes the load from the machine
  # sets machine load to nil
  def remove_clothes
    load.remove_from_machine!(self)
    self.update(load: nil)
  end

  # calculates time_remaining
  def time_remaining
    if self.state == 'in_progress'
      (Time.now - self.end_time).to_s
    else
      return @period
    end
  end

  # @!attribute capacity
  def capacity
    raise 'Subclass responsibility'
  end

  # @!attribute period
  def period
    raise 'Subclass responsibility'
  end

  # @!attribute price
  def price
    raise 'Subclass responsibility'
  end

  #sets capacity, period, and price attributes
  def set_instance_attributes
  end
end
