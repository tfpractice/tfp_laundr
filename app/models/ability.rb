class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    alias_action  :claim, :fill, :unclaim, :insert_coins, :return_coins, :start, :hard_reset, :remove_clothes, :to => :use
    # alias_action  :merge, :remove_from_machine, :to => :handle
    # alias_action :insert, :merge, :wash, :remove_from_machine, :dry, :finish, :to => :handle

    if user.admin?
      can :manage, :all
    else

      can :use, Washer, user: user
      can :use, Dryer, user: user
      can :use, Washer, :state => "available"
      can :use, Dryer, :state => "available"
      can :merge, Load, user: user

      can :manage, Load, user: user

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
