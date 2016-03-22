class MachinesDecorator < Draper::CollectionDecorator
  # delegate_all
  # delegate :accessible_by, :available_machines, :completed_machines, :unavailable_machines
  delegate :accessible_by, :available_machines, :completed_machines, :unavailable_machines, :with_available_state, :with_empty_state, :with_unpaid_state, :with_ready_state, :with_in_progess_state, :with_complete_state, :can_accept_load, :affordable_machines
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
