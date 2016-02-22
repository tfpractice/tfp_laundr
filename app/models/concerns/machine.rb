module Machine
  extend ActiveSupport::Concern
  # module ClassMethods

  # end

  # module InstanceMethods

  # end

  included do
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
      end
      state :ready do
        event :start, :transitions_to => :in_progess
      end
      state :in_progess do
        event :end_cycle, :transitions_to => :complete
      end
      state :complete do
        event :remove_clothes, :transitions_to => :empty
      end
    end
  end

  def claim

  end
  def fill

  end
  def insert_coins(coins=0)

  end
  def start

  end
  def end_cycle

  end
  def remove_clothes

  end
  def unclaim

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
end
