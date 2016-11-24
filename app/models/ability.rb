class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.admin? ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :make_best, Answer, question: { user_id: user.id }

    can :vote_up, [Question, Answer]
    can :vote_down, [Question, Answer]
    cannot :vote_up, [Question, Answer], user_id: user.id
    cannot :vote_down, [Question, Answer], user_id: user.id

    can :destroy, [Attachment], attachable: { user_id: user.id }
  end

  def admin_abilities
    can :manage, :all
  end
end
