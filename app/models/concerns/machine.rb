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
        event :unclaim, :transitions_to => :available
        event :return_coins, :transitions_to => :empty,  if: -> (machine) { machine.coins > 0 }
        event :fill, :transitions_to => :ready, if: -> (machine) { machine.enough_coins? }
        event :fill, :transitions_to => :unpaid
      end
      state :unpaid do
        event :insert_coins, :transitions_to => :ready
        event :return_coins, :transitions_to => :unpaid, if: -> (machine) { machine.coins > 0 }
        event :remove_clothes, :transitions_to => :empty
      end
      state :ready do
        event :return_coins, :transitions_to => :unpaid, if: -> (machine) { machine.coins > 0 }
        event :start, :transitions_to => :in_progress, if: -> (machine) { machine.enough_coins? }
        event :remove_clothes, :transitions_to => :empty
        # on_exit do |from, to, triggering_event, *event_args|
        # puts "from#{from}--"
        # puts "to#{to}--"
        # puts "triggering_event#{triggering_event}"
        # puts "event_args#{event_args}"
        # end
      end
      state :in_progress do
        # on_pending_exit(new_state, event, *args) do
        # end
        event :end_cycle, :transitions_to => :complete
      end
      state :complete do
        event :remove_clothes, :transitions_to => :empty
      end
    end
  end

  # def on_ready_entry(new_state, event, *args)
  # puts "on_ready_entry"
  # puts self.current_state
  # puts "new_state#{new_state}"
  # puts "event#{event}"
  # puts "args#{args}"
  # end
  # def on_ready_exit(new_state, event, *args)
  # puts "on_ready_exit"
  # puts self.current_state

  # puts "new_state#{new_state}"
  # puts "event#{event}"
  # puts "args#{args}"
  # end
  def on_in_progress_entry(new_state, event, *args)
    puts "on_in_progress_entry"
    # args.each { |arg| puts arg }
    # p new_state
    # p event
    
    # puts "current_state#{current_state}"
    # puts "new_state#{new_state}"
    # puts "event#{event}"
    # puts "args#{args}"
    thr = Thread.new do
      #   # Mutex.new.synchronize do
      puts "current machine state"
      puts state
      puts "new_state#{new_state}"

      puts "running thread"
      sleep period
      end_cycle!
    end

   
  end
  # def on_in_progress_exit(*args)
    # puts "exiting in progress"
    # args.each { |arg| puts arg }
  # end
  # def on_ready_exit(*args)
  #   puts "on_ready_exit"
  #   puts "current_state#{current_state}"
  #   args.each { |arg| puts arg }
  # end
  # def showInfo
  #   puts "showInfo called!"
  # end
  # def on_ready_transition(new_state, event, *args)
  # puts "after_ready_transition"
  # puts "new_state#{new_state}"
  # puts "event#{event}"
  # puts "args#{args}"
  # end
  # after_ready_transition
  def claim(user=nil)
    update(user: user)
  end
  def unclaim
    update(user: nil)
  end
  def fill(load=nil)
    begin
      halt! "Cannot insert an empty load" unless load
      halt! "Cannot insert a load heavier than capacity" unless load.weight < @capacity
    rescue Workflow::TransitionHalted => e
      errors.add(:load, e)
    else
      self.update(load: load)
      load.insert(self)
    end
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
    valid_events = []
    current_state.events.each do |event, val|
      if (val.any? { |v| v.condition == nil })
        valid_events << event.id2name
      elsif (val.any? { |v| v.condition != nil })
        valid_conditional_events = val.select { |v| v.condition}.select { |e|  e.condition.call(self) == true  }
        valid_conditional_events.each { |e| valid_events << event.id2name  }
      end
    end
    valid_events
  end
  def insert_coins(count=0)
    begin
      increment!(:coins, count.to_i)
      halt! "machine cannot start until #{self.price} coins are inserted, currently has #{self.coins}" unless enough_coins?
    rescue Workflow::TransitionHalted => e
      errors.add(:coins, e)
    end
  end
  def enough_coins?
    self.coins >= self.price
  end
  def reset_coins
    self.update(coins: 0)
  end
  def start
    @end_time = Time.now + self.period
    # thr = Thread.new do
    #   #   # Mutex.new.synchronize do
    #   # puts "current machine state"
    #   # puts state
    #   sleep period
    #   end_cycle
    # end
    # end
    # return thr
  end
  def end_cycle

    self.reset_coins
  end
  def remove_clothes
    load.remove_from_machine(self)
    self.update(load: nil)
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
  end
end
