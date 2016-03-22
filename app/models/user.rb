class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :loads
  has_many :washers
  has_many :dryers
  # accepts_nested_attributes_for :loads, allow_destroy: true#, reject_if: proc { |attributes| attributes['name'].blank? }

  # has_many :machines
  def reduce_coins(amt=0)
  	decrement!(:coins, amt)
  end
  def increase_coins(amt=0)
  	increment!(:coins, amt)
  end
  def reset_coins
  	update(coins: 20)
  end

end
