class LWasher < Washer

  private
  def set_name
    self.update(name: "Large Washer ##{self.id}" )  unless self.name
  end
  def set_instance_attributes
    @price ||=  14
    @capacity ||= 15.0
    @period ||= 35.0
  end

end
