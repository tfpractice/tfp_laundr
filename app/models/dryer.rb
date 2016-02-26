class Dryer < ActiveRecord::Base
  belongs_to :user


  include Machine
  def initialize(attributes={})
    super()
    # @coins ||= 0
    @price =  1
    @capacity = 15.0
    @period = 5 * @coins
  end
  private
  def set_name
    self.update_column(:name, "Dryer ##{self.id}" )  unless self.name
  end
end
