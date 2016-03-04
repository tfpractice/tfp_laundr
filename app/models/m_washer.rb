class MWasher < Washer
 
  private

  def set_instance_attributes
    @price||=  12
    @capacity||= 10.0
    @period ||= 30.0
  end

  
  def set_name
    self.update(name: "Medium Washer ##{self.id}" )  unless self.name
  end

end
