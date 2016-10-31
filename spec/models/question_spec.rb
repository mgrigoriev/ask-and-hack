require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  describe '#has_vote_up_from?' do
    let(:user)     { create(:user) }
    let(:question) { create(:question) }

    context 'when have votes up from given user' do
      let!(:vote) { create(:vote, value: 1, votable: question, user: user) }

      it { expect(question).to have_vote_up_from(user) }
    end

    context 'when have votes down from given user' do
      let!(:vote) { create(:vote, value: -1, votable: question, user: user) }

      it { expect(question).to_not have_vote_up_from(user) }
    end    

    context 'when have votes up from other user' do
      let(:other_user) { create(:user) }
      let!(:vote) { create(:vote, value: 1, votable: question, user: other_user) }
      
      it { expect(question).to_not have_vote_up_from(user) }
    end

    context 'when doesn\'t have any votes' do
      it { expect(question).to_not have_vote_up_from(user) }
    end
  end

  describe '#has_vote_down_from?' do
    let(:user)     { create(:user) }
    let(:question) { create(:question) }

    context 'when have votes down from given user' do
      let!(:vote) { create(:vote, value: -1, votable: question, user: user) }

      it { expect(question).to have_vote_down_from(user) }
    end

    context 'when have votes up from given user' do
      let!(:vote) { create(:vote, value: 1, votable: question, user: user) }

      it { expect(question).to_not have_vote_down_from(user) }
    end    

    context 'when have votes down from other user' do
      let(:other_user) { create(:user) }
      let!(:vote) { create(:vote, value: -1, votable: question, user: other_user) }
      
      it { expect(question).to_not have_vote_down_from(user) }
    end

    context 'when doesn\'t have any votes' do
      it { expect(question).to_not have_vote_down_from(user) }
    end
  end

  describe '#cancel_vote_from' do
    let(:user)     { create(:user) }
    let(:question) { create(:question) }
    
    context 'when vote exists' do
      let!(:vote)    { create(:vote, value: 1, votable: question, user: user) }
      before { question.cancel_vote_from(user) }
      it { expect(question.votes.find_by(user: user)).to be_nil }    
    end

    context 'when vote doesn\'t exist' do
      before { question.cancel_vote_from(user) }
      it { expect(question.votes.find_by(user: user)).to be_nil }    
    end
  end

  describe '#vote_up' do
    let(:user)       { create(:user) }
    let(:user_other) { create(:user) }
    let(:question)   { create(:question, user: user) }
    
    context "on other user's question" do
      it { expect { question.vote_up(user_other) }.to change{ question.votes.sum(:value) }.by(1) }
    end

    context "on his own question" do
      it { expect { question.vote_up(user) }.to_not change{ question.votes.sum(:value) }}
    end

    # Повторное голосование работает как отмена голоса
    context "when previously voted up" do
      let!(:vote_prev) { create(:vote, value: 1, votable: question, user: user_other) }
      it { expect { question.vote_up(user_other) }.to change{ question.votes.sum(:value) }.by(-1) }
    end

    context "when previously voted down" do
      let!(:vote_prev) { create(:vote, value: -1, votable: question, user: user_other) }
      it { expect { question.vote_up(user_other) }.to change{ question.votes.sum(:value) }.by(2) }
    end
  end

  describe '#vote_down' do
    let(:user)       { create(:user) }
    let(:user_other) { create(:user) }
    let(:question)   { create(:question, user: user) }
    
    context "on other user's question" do
      it { expect { question.vote_down(user_other) }.to change{ question.votes.sum(:value) }.by(-1) }
    end

    context "on his own question" do
      it { expect { question.vote_down(user) }.to_not change{ question.votes.sum(:value) }}
    end

    # Повторное голосование работает как отмена голоса
    context "when previously voted down" do
      let!(:vote_prev) { create(:vote, value: -1, votable: question, user: user_other) }
      it { expect { question.vote_down(user_other) }.to change{ question.votes.sum(:value) }.by(1) }
    end

    context "when previously voted up" do
      let!(:vote_prev) { create(:vote, value: 1, votable: question, user: user_other) }
      it { expect { question.vote_down(user_other) }.to change{ question.votes.sum(:value) }.by(-2) }
    end
  end

end
