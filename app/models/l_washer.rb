class LWasher < Washer
  def initialize(attributes={})
    super()
    @price =  14
    @capacity = 15.0
    @period = 35.0
  end
  private
  def set_name
    self.update(:name, "Large Washer ##{self.id}" )  unless self.name
  end

end
