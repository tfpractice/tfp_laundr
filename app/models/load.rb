# A load of clothing
class Load < ActiveRecord::Base
  include Workflow

  # AR Relations
  belongs_to :user
  belongs_to :machine, polymorphic: true

  # acts as list scoped to user
  acts_as_list scope: :user

  # callbacks
  before_save :set_weight, on: :create
  after_save :set_name, on: :create
  after_create :set_dry_time

  # validations
  validates_presence_of :user
  validates :weight, numericality: { greater_than_or_equal_to: 0 }
  # attr_accessor :dry_time
  # named scopes
  scope :dirty_loads, -> { where(state: 'dirty') }
  scope :in_washer_loads, -> { where(state: 'in_washer') }
  scope :washed_loads, -> { where(state: 'washed') }
  scope :wet_loads, -> { where(state: 'wet') }
  scope :in_dryer_loads, -> { where(state: 'in_dryer') }
  scope :dried_loads, -> { where(state: 'dried') }
  scope :can_fit_machine, ->(machine) { where('weight<= ?', machine.capacity) }
  scope :same_state, ->(load) { where(state: load.state) }

  # state machine behavior
  workflow_column :state
  workflow do
    state :dirty do
      event :insert, transitions_to: :in_washer
      event :merge, transitions_to: :dirty
      event :split, transitions_to: :dirty
    end
    state :in_washer do
      event :wash, transitions_to: :washed
      event :remove_from_machine, transitions_to: :dirty
    end
    state :washed do
      event :remove_from_machine, transitions_to: :wet
    end
    state :wet do
      event :insert, transitions_to: :in_dryer
      event :merge, transitions_to: :wet
      event :split, transitions_to: :wet
    end
    state :in_dryer do
      event :dry, transitions_to: :dried
      event :remove_from_machine, transitions_to: :wet
    end
    state :dried do
      event :fold, transitions_to: :folded
      event :merge, transitions_to: :dried
      event :remove_from_machine, transitions_to: :clean
    end
    state :folded do
      event :finish, transitions_to: :clean
    end
    state :clean do
      event :soil, transitions_to: :dirty
    end
  end
  # @deprecated
  def insert(machineArg = nil)
    begin
      raise ArgumentError, 'Cannot insert a load if machine is nil' unless machineArg
      halt! 'Cannot insert a load if machine is nil' unless machineArg
    rescue  Workflow::TransitionHalted, ArgumentError => e
      errors.add(:machine, e)
    else
      update(machine: machineArg) unless machineArg.load == self
    end
  end

  # if load is currently associated
  # with a machine sets load machine to nil
  # @param [Washer, Dryer] machine
  def remove_from_machine(machine = nil)
    update(machine: nil) if self.machine
  end

  # @todo
  def split
  end

  # washes the load and sets
  # state to 'in_washer' if current machine
  # is a washer, else raises error
  # and halts transition
  def wash
    begin
      halt! 'Can only wash if current machine is a Washer' unless self.machine.is_a? Washer
    rescue Workflow::TransitionHalted => e
      errors.add(:machine, e)
    end
  end

  # drys the load for set duration,
  # reduces load dry_time, and sets
  # state to 'in_dryer' if current machine
  # is a dryer, else raises error
  # and halts transition
  def dry(duration=0)
    begin
      decrement(:dry_time, duration.to_i)
      halt! 'load has not dried for long enough' if dry_time > 0
    rescue Workflow::TransitionHalted => e
      errors.add(:machine, e)
    end
  end

  # sets load machine to nil
  # sets state to 'dirty'
  def hard_reset
    update(machine: nil, state: 'dirty')
  end

  # @todo
  def fold
  end

  # @todo
  def finish
  end

  # @todo
  def soil
  end

  # checks if current load and
  # second_load have equivalent states
  # @param [Load] second_load
  # @return [Boolean]
  def same_state?(second_load)
    self.state == second_load.state unless !second_load
  end

  # checks if current load and
  # second_load belong to the same user
  # @param [Load] second_load
  # @return [Boolean]
  def shared_user?(second_load = nil)
    self.user == second_load.user
  end

  # combines the weight of current load
  # and second_load
  # iff second_load is present,
  # second_load has a weight greater than zero
  # second_load hasme state
  # second_load belongs to same user
  # @param [Load] second_load
  def merge(second_load = nil)
    begin
      halt! "cannot merge with an empty load" unless second_load
      halt! "Cannot merge loads with different states. Load is currently #{self.state }, merging load is #{second_load.state }" unless same_state?(second_load)
      halt! "Cannot merge loads wih different users. Current Load belongs to #{self.user.username }, merging load belongs to #{second_load.user.username}" unless shared_user?(second_load)
    rescue Workflow::TransitionHalted, ArgumentError => e
      errors.add(:weight, e)
    else
      increment!(:weight, second_load.weight)
      second_load.destroy
    end
  end

  # returns 'merge' as valid event
  # dependent upon state
  # @return [Array] valid_events
  def next_steps
    valid_events = []
    valid_events << 'merge' if can_merge?
    valid_events
  end

  private

  # sets the weight if weight is unassigned
  def set_weight
    @weight = self.read_attribute(:weight) || 0
  end

  # sets dry_time based on weight
  def set_dry_time
    update(dry_time: 5 * weight)
  end

  # if load name is blank,
  # sets name based on weight and id
  def set_name
    self.update(name: "#{self.weight}lbs.—Load ##{self.id}") if self.name.blank?
  end
end
