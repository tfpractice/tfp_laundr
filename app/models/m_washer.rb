class MWasher < Washer
  def initialize(attributes={})
    super()
    @price =  12
    @capacity = 10.0
    @period = 30.0
  end
  private
  def set_name
    self.update_column(:name, "Medium Washer ##{self.id}" )  unless self.name
  end

end
