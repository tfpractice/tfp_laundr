class Washer < ActiveRecord::Base
  include Workflow

  belongs_to :user


  workflow_column :state

  workflow do
    state :available do
      event :claim, :transitions_to => :empty
    end
    state :empty do
      event :fill, :transitions_to => :unpaid
    end
    state :unpaid do
      # event :fill, :transitions_to => :unpaid
    end
  end

  def claim

  end
  def fill

  end
  def insert_coins(coins=0)

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
