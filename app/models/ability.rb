class Ability
  include CanCan::Ability
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.get_guest # guest user (not logged in)
    alias_action  :claim, :fill, :unclaim, :insert_coins, :return_coins, :start,  :remove_clothes, :to => :use
    if user.admin?
      can :manage, :all
    else
     
      can :use, [Washer, Dryer], user: user 
      can :claim, [Washer, Dryer], state: "available"
      can :use, MachineDecorator, user: user 
      can :claim, MachineDecorator, state: "available"
      can :manage, Load, user: user
      can :manage, LoadDecorator, user: user
      can :read, :all
    end
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
