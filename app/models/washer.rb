class Washer < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :type
  skip_callback :initialize, :after, :set_name, :set_instance_attributes, if: -> { self.class.name == "Washer"}

  # validates :type,  inclusion: {in: self.descendants}



  include Machine

  def set_name
    #   self.name ||= "Washer_#{self.id}"
  end
  def set_instance_attributes
    super
    puts @coins
  end
end
