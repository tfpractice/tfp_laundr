# Users with Devise and Cancancan
class User < ActiveRecord::Base
  # Default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # AR relationships
  has_many :loads, dependent: :destroy
  has_many :washers
  has_many :dryers

  # named scopes
  scope :guests, -> { where(guest: true) }

  # decrements  users coins by
  # the amount parameter
  # @param [Fixnum] amt = 0
  def reduce_coins(amt = 0)
    decrement!(:coins, amt)
  end

  # increments  users coins by
  # the amount parameter
  # @param [Fixnum] amt = 0
  def increase_coins(amt = 0)
    increment!(:coins, amt)
  end

  # sets users coins to 20
  def reset_coins
    update(coins: 20)
  end

  # calculate the total weight
  # of all users loads
  # sets laundry to this total
  # using default accessor #landry=
  # @return [Float] laundry
  def laundry
    laundry = loads.pluck(:weight).sum
  end

  # calls hard_reset on each of the claimed machines
  # if any, then calls hard_reset on each
  # of the users loads
  def hard_reset
    washers.each { |w| w.hard_reset } if washers
    washers.clear
    dryers.each { |d| d.hard_reset } if dryers
    dryers.clear
    loads.each { |l| l.hard_reset } if loads
  end

  # creates a new user with the guest attribute
  # set to true
  # @return [User]
  def self.get_guest
    create(username: "guest_#{rand(1000)}", email: "guest_#{rand(100)}@example.com", admin: false, laundry: 0, guest: true, coins: 20)
  end
end
