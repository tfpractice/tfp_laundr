# A Medium washer
class MWasher < Washer

  private

  # sets name attribute based on size and db id
  def set_name
    self.update(name: "Medium Washer ##{self.id}") unless self.name
  end

  # @!attribute [Fixnum] price = 12
  # @!attribute [Float] capacity = 10.0
  # @!attribute [Float] period = 30.0
  def set_instance_attributes
    @price ||= 12
    @capacity ||= 10.0
    @period ||= 30.0
  end
end
