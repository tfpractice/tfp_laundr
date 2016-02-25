class SWasher < Washer
  # after_save :set_name, on: [:create, :new]

  def initialize(attributes={})
    super()
    @price = 8
    @capacity = 5.0
    @period = 20.0
  end

  private

  def set_name
    self.update_column(:name, "Small Washer ##{self.id}" ) unless self.name
  end
 
end
