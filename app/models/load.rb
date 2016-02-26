class Load < ActiveRecord::Base
  include Workflow
  belongs_to :user
  belongs_to :machine, polymorphic: true
  acts_as_list scope: :user
  before_save :set_weight, :set_dry_time,  on: :create
  # after_initialize :set_weight, :set_dry_time, on: :create
  attr_accessor :dry_time



  workflow_column :state

  workflow do
    state :dirty do
      event :insert, :transitions_to => :in_washer

    end
    state :in_washer do
      event :wash, :transitions_to => :washed
      event :remove_from_machine, :transitions_to => :dirty
    end
    state :washed do
      event :remove_from_machine, :transitions_to => :ready_to_dry

    end
    state :ready_to_dry do
      event :insert, :transitions_to => :in_dryer
    end
    state :in_dryer do
      event :dry, :transitions_to => :dried
      event :remove_from_machine, :transitions_to => :ready_to_dry

    end
    state :dried do
      event :fold, :transitions_to => :folded
      event :finish, :transitions_to => :clean
    end
    state :folded do
      event :finish, :transitions_to => :clean
    end
    state :clean do
      event :soil, :transitions_to => :dirty
    end
    # state :in_progess do
    #   event :end_cycle, :transitions_to => :complete
    # end
    # state :complete do
    #   event :remove_clothes, :transitions_to => :empty
    # end
  end


  def insert(machine = nil)
    update(machine: machine)
  end
  def remove_from_machine(machine = nil)
    if self.machine
      update(machine: nil)
    end
  end
  def wash
    raise "Can only wash if current machine is a Washer" unless self.machine.is_a? Washer

  end
  def dry(duration = 0)
    if self.machine.is_a? Dryer
      @dry_time -= duration
      false unless @dry_time <= 0
    else
      raise "Cannot Dry if current machine is not a dryer"
    end

  end
  def fold

  end
  def finish

  end
  def soil

  end
  def merge

  end

  private
  def set_weight
    @weight = self.read_attribute(:weight) || 0
    # self.weight = initWeight || 0
    # puts "selfweight,#{self.weight}"
    # puts "weight, #{@weight}"

  end
  def set_dry_time
    @dry_time = @weight * 5
  end
end
