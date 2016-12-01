class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_abilities(user) : guest_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities(user)
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Attachment], attachable: { user_id: user.id }
    can :assign_best, Answer, question: { user_id: user.id }
    can :vote_plus, [Question, Answer]
    can :vote_minus, [Question, Answer]
    can :vote_cancel, [Question, Answer]

    cannot :vote_plus, [Question, Answer], user_id: user.id
    cannot :vote_minus, [Question, Answer], user_id: user.id
    cannot :vote_cancel, [Question, Answer], user_id: user.id
  end
end
