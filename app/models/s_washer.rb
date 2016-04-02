# A small washer
class SWasher < Washer

  private

  def put_attributes
    puts self.attributes
  end

  # sets name attribute based on size and db id
  def set_name
    self.update(name: "Small Washer ##{self.id}" ) unless self.name
  end

  # @!attribute [Fixnum] price = 8
  # @!attribute [Float] capacity = 5.0
  # @!attribute [Float] period = 20.0
  def set_instance_attributes
    @price ||= 8
    @capacity ||= 5.0
    @period ||= 20.0
  end
end
