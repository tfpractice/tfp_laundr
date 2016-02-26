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

      event :wash, :transitions_to => :washed
    end
    state :washed do
      event :dry, :transitions_to => :dried
      # event :merge, :transitions_to => :available
      # event :separate, :transitions_to => :available
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

  end
  def dry(duration = 0)
    @dry_time -= duration
    false unless @dry_time <= 0
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
    initWeight = self.read_attribute(:weight)
    self.weight = initWeight || 0


  end
  def set_dry_time
    @dry_time = self.weight * 5
  end
end
