class Washer < ActiveRecord::Base
  belongs_to :user

  include Machine
  
end
