# Dries the load belonging to the claimed user
class Dryer < ActiveRecord::Base
  # belongs_to :user
  include Machine

  def start
    super
    load.dry!(period)
  end
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

  private
  # Dryer.workflow_spec.states[:ready].events.push(:insert_coins,(Workflow::Event.new(:insert_coins, :ready)))
  def self.append_workflow
    self.workflow_spec.states[:ready].events.push(:insert_coins,(Workflow::Event.new(:insert_coins, :ready)))
    self.workflow_spec.states[:in_progress].events.push(:insert_coins,(Workflow::Event.new(:insert_coins, :in_progress)))
    self.workflow_spec.states[:complete].events.push(:insert_coins,(Workflow::Event.new(:insert_coins, :ready)))
  end
  append_workflow
end
