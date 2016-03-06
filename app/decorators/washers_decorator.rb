class WashersDecorator < Draper::CollectionDecorator

  delegate :accessible_by, :available_machines, :completed_machines, :unavailable_machines
 
end
