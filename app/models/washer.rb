class Washer < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :type
  # validates :type,  inclusion: {in: self.descendants}



  include Machine

end
