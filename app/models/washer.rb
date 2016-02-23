class Washer < ActiveRecord::Base
  belongs_to :user
    validates_presence_of :type
    # validates :type,  inclusion: {in: self.descendants}


  include Machine

  # def claim(user=nil)
  # 	update_attribute(:user, user)
  # end

end
