class Ability
  include CanCan::Ability

  def initialize(user)
    #binding.pry
    user ||= User.new

    can :read, Article, status: :published

    if user.has_role? :user
      can :read, Article, status: :published
      can :manage, [Article, Comment], user: user
      can [:update, :show], User, id: user.id
    elsif user.has_role? :admin
      can :manage, :all
    end
  end
end
