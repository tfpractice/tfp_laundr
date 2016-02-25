module Machine
  extend ActiveSupport::Concern
  attr_accessor :coins
  # attr_reader :price, :capacity, :period

  def initialize(attributes={})
    super()
    @coins = 0
  end


  included do
    attr_reader :price, :capacity, :period


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


  def claim(user=nil)
    update_attribute(:user, user)
  end
  def unclaim
    update_attribute(:user, nil)

  end
  def fill

  end
  def insert_coins(count=0)
    @price ||= count
    if @coins + count > @price
      raise "Cannot supply more than #{@price} coins"
    else
      @coins += count

    end

  end
  def start
    # end_cycle!

  end
  def end_cycle

  end
  def remove_clothes

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
