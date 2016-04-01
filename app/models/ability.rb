# Use CanCanCan to manage user permissions.
# Due to the DraperGems return type [Decorator], permissions are set on Decorators where applied, and not onto the decorated objects themselves.
# In the case that Draper is removed, this behavior is backed up by adding permissions onto the objects themselves.

class Ability


  include CanCan::Ability

  # admin users can :manage all records
  # other logged in users can :use Washers and Dryers that are available or claimed by that user
  # users can manage loads which belong to them

  # @param user [User] the current user or guest user
  # @return [CanCan::Ability] ability based on user role

  def initialize(user)
    user ||= User.new
    alias_action  :claim, :fill, :unclaim, :insert_coins, :return_coins, :start,  :remove_clothes, :to => :use
    if user.admin?
      can :manage, :all
    elsif user.new_record?
      can :read, :all

    else

      can :use, [Washer, Dryer], user: user
      can :use, [Washer, Dryer], state: "available"
      can :use, MachineDecorator, state: "available"
      can :use, MachineDecorator, user: user

      can :manage, Load, user: user
      can :manage, LoadDecorator, user: user
      can :read, :all
    end

  end

end
