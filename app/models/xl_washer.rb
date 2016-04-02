# An Extra-Large washer
class XlWasher < Washer

  private

  # sets name attribute based on size and db id
  def set_name
    self.update(name: "Xtra-Large Washer ##{self.id}") unless self.name
  end

  # @!attribute [Fixnum] price = 16
  # @!attribute [Float] capacity = 20.0
  # @!attribute [Float] period = 45.0
  def set_instance_attributes
    @price ||= 16
    @capacity ||= 20.0
    @period ||= 45.0
  end
end
