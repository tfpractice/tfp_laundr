class MWasher < Washer
  attr_accessor :price, :capacity, :period
  # before_save :output_attrs
  after_save :output_attrs
  # after_initialize :set_attrs


  # def initialize(attributes={})
  #   super()
   
  # end


  # def fill(load=nil)
  #   # puts @capacity
  #   # puts "capacity#{self.capacity}"
  #   # puts load.inspect
  #   if !load
  #     raise "Cannot insert an empty load "

  #   elsif load.weight <= @capacity

  #     self.update(load: load)
  #     reduce_capacity(load.weight)

  #   else
  #     raise "Cannot insert a loadheavier than capacity"
  #   end
  #   # unless load.weight <= capacity

  # end
  # def capacity
  # 10
  #
  # end
  private
  def output_attrs
    # puts "outputting attributes"
    # puts "capacity#{@capacity}"
    # puts "price#{@price}"
    # puts "period#{@period}"


  end
  def set_instance_attributes
    @price||=  12
    @capacity||= 10.0
    @period ||= 30.0
  end

  def change_attrs
    @price-=  5
    @capacity-= 1.0
    @period-= 5.0
    output_attrs
    puts "SAVING OBJECT"
    self.save
    alter_attrs
  end
  def alter_attrs
    @price-=  5
    @capacity-= 1.0
    @period-= 5.0
    output_attrs
    puts "Altered OBJECT"
    self.save
  end
  def set_name
    self.update(name: "Medium Washer ##{self.id}" )  unless self.name
  end

end
