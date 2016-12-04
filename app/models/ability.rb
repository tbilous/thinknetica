class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    alias_action :update, :destroy, to: :modify
    alias_action :vote_plus, :vote_minus, :vote_cancel, to: :vote

    user ? user_abilities(user) : guest_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities(user)
    guest_abilities

    can :create, [Question, Answer, Comment]

    can :modify, [Question, Answer, Comment], user_id: user.id

    can :destroy, [Attachment], attachable: { user_id: user.id }

    can :assign_best, Answer, question: { user_id: user.id }

    can :vote, [Question, Answer] do |resource|
      resource.user_id != user.id
    end

    can :me, User
  end
end
