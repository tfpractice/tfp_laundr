class Washer < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :type
 skip_callback :save, :after, :set_name, if: -> { self.class.name == "Washer"}

  # validates :type,  inclusion: {in: self.descendants}



  include Machine

  def set_name
  #   self.name ||= "Washer_#{self.id}"
  end

end
