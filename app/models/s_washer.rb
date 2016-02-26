class SWasher < Washer
  # after_save :set_name, on: [:create, :new]
  # after_initialize :set_instance_attributes

  def initialize(attributes={})
    super()
    @price ||= 8
    @capacity ||= 5.0
    @period ||= 20.0
  end

  private
  def put_attributes
    puts self.attributes

  end
  def set_name
    # self.update_column(:name, "Small Washer ##{self.id}" ) unless self.name
    self.update(name: "Small Washer ##{self.id}" ) unless self.name
  end
  # def set_instance_attributes
    # @coins ||= 0
    # @price ||= 8
    # @capacity ||= 5.0
    # @period ||= 20.0
  # end

end
