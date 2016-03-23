class Load < ActiveRecord::Base
  include Workflow
  belongs_to :user
  belongs_to :machine, polymorphic: true
  acts_as_list scope: :user
  before_save :set_weight, on: :create
  after_save :set_name,  on: :create
  after_create :set_dry_time#, :update_user_laundry
  validates_presence_of :user
  validates :weight, numericality: { greater_than_or_equal_to: 0 }
  # attr_accessor :dry_time
  scope :dirty_loads, -> {where(state: "dirty")}
  scope :in_washer_loads, -> {where(state: "in_washer")}
  scope :washed_loads, -> {where(state: "washed")}
  scope :wet_loads, -> {where(state: "wet")}
  scope :in_dryer_loads, -> {where(state: "in_dryer")}
  scope :dried_loads, -> {where(state: "dried")}
  scope :can_fit_machine, ->(machine) {where("weight<= ?", machine.capacity)}
  scope :same_state, ->(load) {where(state: load.state)}
  workflow_column :state
  workflow do
    state :dirty do
      event :insert, :transitions_to => :in_washer
      event :merge, :transitions_to => :dirty#, :if => proc {|machine, secondLoad| machine}
      event :split, :transitions_to => :dirty
    end
    state :in_washer do
      event :wash, :transitions_to => :washed
      event :remove_from_machine, :transitions_to => :dirty
    end
    state :washed do
      event :remove_from_machine, :transitions_to => :wet
    end
    state :wet do
      event :insert, :transitions_to => :in_dryer
      event :merge, :transitions_to => :wet
      event :split, :transitions_to => :wet

    end
    state :in_dryer do
      event :dry, :transitions_to => :dried #, if: ->(load) {load.dry_time <=0}
      # event :dry, :transitions_to => :in_dryer#, if: ->(load) {load.dry_time > 0}

      event :remove_from_machine, :transitions_to => :wet
    end
    state :dried do
      event :fold, :transitions_to => :folded
      event :merge, :transitions_to => :dried
      event :remove_from_machine, :transitions_to => :clean
    end
    state :folded do
      event :finish, :transitions_to => :clean
    end
    state :clean do
      event :soil, :transitions_to => :dirty
    end
  end
  def insert(machineArg = nil)
    begin
      raise ArgumentError,"Cannot insert a load if machine is nil" unless machineArg
      halt! "Cannot insert a load if machine is nil" if !machineArg
    rescue  Workflow::TransitionHalted, ArgumentError => e
      errors.add(:machine, e)
    else
      # puts "load is being inserted"
      update(machine: machineArg) unless machineArg.load == self


    end
  end
  def remove_from_machine(machine = nil)
    if self.machine
      update(machine: nil)
    end
  end
  def split
    
  end
  def wash
    begin
      halt! "Can only wash if current machine is a Washer" unless self.machine.is_a? Washer
    rescue Workflow::TransitionHalted => e
      errors.add(:machine, e)

    end
  end
  def dry(duration=0)
    begin
      # puts "duration#{duration}"
      # halt! "Can only dry if current machine is a Dryer" unless self.machine.is_a? Dryer
      # puts "current dry_time#{dry_time}"
      # puts "new dry_time#{dry_time-duration}"
      decrement(:dry_time, duration.to_i)
      # puts "decremented dry_time#{self.dry_time}"
      halt! "load has not dried for long enough" if dry_time > 0
    rescue Workflow::TransitionHalted => e
      errors.add(:machine, e)

    end
  end
  def hard_reset
    update(machine: nil, state: "dirty")
    
  end
  def fold
  end
  def finish
  end
  def soil
  end
  def same_state?(secondLoad)
    self.state == secondLoad.state unless !secondLoad
  end
  def merge(secondLoad=nil)
    begin
      halt! "cannot merge with an empty load" if !secondLoad
      halt! "Cannot merge loads with different states. Load is currently #{self.state}, merging load is #{secondLoad.state}" if !same_state?(secondLoad)
      halt! "Cannot merge loads wih different users. Current Load belongs to #{self.user.username}, merging load belongs to #{secondLoad.user.username}" if !shared_user?(secondLoad)
    rescue Workflow::TransitionHalted, ArgumentError => e
      errors.add(:weight, e)
    else
      increment!(:weight, secondLoad.weight)
      secondLoad.destroy
    end
  end
  def shared_user?(secondLoad = nil)
    self.user == secondLoad.user
  end
  def next_steps
    # "merge" if current_state.events.include?(:merge)
    valid_events = []
    valid_events << "merge" if can_merge?
    # "merge" if current_state.events.select { |e| e.id2name == "merge" }

    # current_state.events
    # valid_events = []
    # current_state.events.each do |event, val|
    # if (val.any? { |v| v.condition == nil })
    # valid_events << event.id2name
    # elsif (val.any? { |v| v.condition != nil })
    # valid_conditional_events = val.select { |v| v.condition}.select { |e|  e.condition.call(self) == true  }
    # valid_conditional_events.each { |e| valid_events << event.id2name  }
    # end
    # end
    valid_events
  end
  private
  def set_weight
    @weight = self.read_attribute(:weight) || 0
  end
  def set_dry_time
    # # puts "@weight#{@weight}"
    # # puts "#self.weight#{self.weight}"
    # # puts "weight#{weight}"
    update(dry_time: 5*weight)
    # dry_time = weight * 5
    # # puts "dry_time#{dry_time}"
    # # puts "self.dry_time#{self.dry_time}"
    # # puts "self.attributes[:dry_time]#{attributes['dry_time']}"
  end
  # def update_user_laundry
    # user.calculate_laundry
    
  # end
  def set_name
    self.update(name: "#{self.weight}lbs.— Load ##{self.id}" ) if self.name.blank?
  end
end
