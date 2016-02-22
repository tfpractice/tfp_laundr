class Washer < ActiveRecord::Base
  include Workflow

  belongs_to :user


  workflow_column :state

  workflow do
    state :available do
      # event :submit, :transitions_to => :awaiting_review
    end
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
