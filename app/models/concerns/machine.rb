module Machine
  extend ActiveSupport::Concern

  included do
    attr_accessor  :price, :capacity, :period, :end_time
    has_one :load, as: :machine
    belongs_to :user
    after_save :set_name, on: [:create, :new]
    after_initialize  :set_instance_attributes
    # after_initialize :set_count

    scope :available_machines, -> {where(state: "available")}
    scope :completed_machines, -> {where(state: "complete")}
    scope :unavailable_machines, -> {where.not(state: "available")}
    # scope :available_machines, -> {where(state: "available")}
    # scope :available_machines, -> {where(state: "available")}
    # scope :available_machines, -> {where(state: "available")}


    include Workflow
    acts_as_list


    workflow_column :state

    workflow do
      state :available do
        event :claim, :transitions_to => :empty
      end
      state :empty do
        event :fill, :transitions_to => :unpaid
        event :unclaim, :transitions_to => :available
      end
      state :unpaid do
        event :insert_coins, :transitions_to => :ready
        event :remove_clothes, :transitions_to => :empty

      end
      state :ready do
        event :start, :transitions_to => :in_progess
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
  def reduce_capacity(weight=0)
    @capacity -= weight
  end
  def reduce_price
    @price -= @coins

  end
  def next_steps
    current_state.events.collect { |event, val|  event.id2name}
  end
  def insert_coins(ccount=0)
  increment!(:coins, ccount.to_i)
  # increment(:count, ccount.to_i)
  end
  # def reset
  # self.update
  # end
  def start
    @end_time = Time.now + self.period
    end_cycle if Time.now > self.end_time

  end
  def end_cycle

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
