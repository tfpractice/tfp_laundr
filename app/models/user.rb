class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :loads, dependent: :destroy
  has_many :washers
  has_many :dryers
  scope :guests, ->{where(guest: true)}

  
  def reduce_coins(amt=0)
    decrement!(:coins, amt)
  end
  def increase_coins(amt=0)
    increment!(:coins, amt)
  end
  def reset_coins
    update(coins: 20)
  end
  def laundry
    laundry = loads.pluck(:weight).sum
  end
  def hard_reset
    washers.each { |w| w.hard_reset } if washers
    washers.clear
    dryers.each { |d| d.hard_reset } if dryers
    dryers.clear
    loads.each { |l| l.hard_reset } if loads
    
  end

  def self.get_guest
    create(:username => "guest_#{rand(1000)}", :email => "guest_#{rand(100)}@example.com", :admin => false, :laundry => 0, :guest => true, coins: 20)


  end
end
