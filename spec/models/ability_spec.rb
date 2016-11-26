require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)            { create(:user) }
    let(:other_user)      { create(:user) }
    let(:his_question)    { create(:question, user: user) }
    let(:others_question) { create(:question, user: other_user) }
    let(:his_answer)      { create(:answer, user: user) }
    let(:others_answer)   { create(:answer, user: other_user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # Update
    it { should be_able_to :update, his_question }
    it { should_not be_able_to :update, others_question }

    it { should be_able_to :update, his_answer }
    it { should_not be_able_to :update, others_answer }

    # Destroy
    it { should be_able_to :destroy, his_question }
    it { should_not be_able_to :destroy, others_question }

    it { should be_able_to :destroy, his_answer }
    it { should_not be_able_to :destroy, others_answer }

    # Make best answer
    it { should be_able_to :make_best, create(:answer, question: his_question) }
    it { should_not be_able_to :make_best, create(:answer, question: others_question) }

    # Votes
    it { should be_able_to :vote_up, others_question }
    it { should_not be_able_to :vote_up, his_question }

    it { should be_able_to :vote_down, others_question }
    it { should_not be_able_to :vote_down, his_question }

    it { should be_able_to :vote_up, create(:answer) }
    it { should_not be_able_to :vote_up, his_answer }

    it { should be_able_to :vote_down, create(:answer) }
    it { should_not be_able_to :vote_down, his_answer }

    # Attachments
    it { should be_able_to :destroy, his_question.attachments.build }
    it { should_not be_able_to :destroy, others_question.attachments.build }

    it { should be_able_to :me, User }
    it { should be_able_to :read, User }
  end
end
