class XlWasher < Washer

  def initialize(attributes={})
    super()
    @price =  16
    @capacity = 20.0
    @period = 45.0
  end
  private
  def set_name
    self.update(:name, "Xtra-Large Washer ##{self.id}" )  unless self.name
  end

end
