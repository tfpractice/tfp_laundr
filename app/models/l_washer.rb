# A Large washer
class LWasher < Washer
  private

  # sets name attribute based on size and db id
  def set_name
    self.update(name: "Large Washer ##{self.id}") unless self.name
  end

  # @!attribute [Fixnum] price = 14
  # @!attribute [Float] capacity = 15.0
  # @!attribute [Float] period = 35.0
  def set_instance_attributes
    @price ||= 14
    @capacity ||= 15.0
    @period ||= 35.0
  end
end
