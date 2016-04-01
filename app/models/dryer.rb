# Dries the load belonging to the claiming user
class Dryer < ActiveRecord::Base
  include Machine

  # starts the cycle
  # dries load for alooted period
  def start
    super
    load.dry!(period)
  end

  # calls module #insert_coin
  # adjusts period for every coin inserted
  def insert_coins(count = 0)
    super
    self.period += (5 * count.to_i)
  end

  private

  # sets name attribute based on db id
  def set_name
    self.update(name: "Dryer ##{self.id}") unless self.name
  end

  # sets common attributes for Dryer
  # @!attribute price = 1
  # @!attribute capacity = 15
  # @!attribute period = 5*coins
  def set_instance_attributes
    @price ||= 1
    @capacity ||= 15.0
    @period ||= 5 * self.coins
  end

  # As dryers can receive coins during more states
  # than washers, this  method adds #insert_coins
  # as a possible event to these states
  def self.append_workflow
    self.workflow_spec.states[:ready].events.push(:insert_coins, Workflow::Event.new(:insert_coins, :ready))
    self.workflow_spec.states[:in_progress].events.push(:insert_coins, Workflow::Event.new(:insert_coins, :in_progress))
    self.workflow_spec.states[:complete].events.push(:insert_coins, Workflow::Event.new(:insert_coins, :ready))
  end
  append_workflow
end
