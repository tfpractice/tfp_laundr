class SWasher < Washer
  # after_save :set_name, on: [:create, :new]
  # after_initialize :set_instance_attributes

  # def initialize(attributes={})
  #   super()
  #   self.price ||= 8
  #   self.capacity ||= 5.0
  #   self.period ||= 20.0
  # end

  private
  def put_attributes
    puts self.attributes

  end
  def set_name
    # self.update_column(:name, "Small Washer ##{self.id}" ) unless self.name
    self.update(name: "Small Washer ##{self.id}" ) unless self.name
  end
  def set_instance_attributes
    @price ||= 8
    @capacity ||= 5.0
    @period ||= 20.0
  end
  # def set_instance_attributes
  # @coins ||= 0
  # @price ||= 8
  # @capacity ||= 5.0
  # @period ||= 20.0
  # end
  # def output_attrs
  # puts "outputting attributes"
  # puts "capacity#{@capacity}"
  # puts "price#{@price}"
  # puts "period#{@period}"


  # end
  # def change_attrs
  #   @price-=  5
  #   @capacity-= 1.0
  #   @period-= 5.0
  #   output_attrs
  #   puts "SAVING OBJECT"
  #   self.save
  #   alter_attrs
  # end
  # def alter_attrs
  #   @price-=  5
  #   @capacity-= 1.0
  #   @period-= 5.0
  #   output_attrs
  #   puts "Altered OBJECT"
  #   self.save
  # end

end
