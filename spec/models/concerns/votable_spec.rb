require 'rails_helper'

shared_examples 'votable' do

  describe '#has_vote_up_from?' do
    let(:user)  { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym) }

    context 'when have votes up from given user' do
      let!(:vote) { create(:vote, value: 1, votable: model, user: user) }

      it { expect(model).to have_vote_up_from(user) }
    end

    context 'when have votes down from given user' do
      let!(:vote) { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model).to_not have_vote_up_from(user) }
    end    

    context 'when have votes up from other user' do
      let(:other_user) { create(:user) }
      let!(:vote) { create(:vote, value: 1, votable: model, user: other_user) }
      
      it { expect(model).to_not have_vote_up_from(user) }
    end

    context 'when doesn\'t have any votes' do
      it { expect(model).to_not have_vote_up_from(user) }
    end
  end

  describe '#has_vote_down_from?' do
    let(:user)  { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym) }

    context 'when have votes down from given user' do
      let!(:vote) { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model).to have_vote_down_from(user) }
    end

    context 'when have votes up from given user' do
      let!(:vote) { create(:vote, value: 1, votable: model, user: user) }

      it { expect(model).to_not have_vote_down_from(user) }
    end    

    context 'when have votes down from other user' do
      let(:other_user) { create(:user) }
      let!(:vote) { create(:vote, value: -1, votable: model, user: other_user) }
      
      it { expect(model).to_not have_vote_down_from(user) }
    end

    context 'when doesn\'t have any votes' do
      it { expect(model).to_not have_vote_down_from(user) }
    end
  end

  describe '#cancel_vote_from' do
    let(:user)  { create(:user) }
    let(:model) { create(described_class.to_s.underscore.to_sym) }
    
    context 'when vote exists' do
      let!(:vote)    { create(:vote, value: 1, votable: model, user: user) }
      before { model.cancel_vote_from(user) }
      it { expect(model.votes.find_by(user: user)).to be_nil }    
    end

    context 'when vote doesn\'t exist' do
      before { model.cancel_vote_from(user) }
      it { expect(model.votes.find_by(user: user)).to be_nil }    
    end
  end

  describe '#vote_up' do
    let(:user)       { create(:user) }
    let(:user_other) { create(:user) }
    let(:model)      { create(described_class.to_s.underscore.to_sym, user: user) }
    
    context "on other user's post" do
      it { expect { model.vote_up(user_other) }.to change{ model.votes.sum(:value) }.by(1) }
    end

    context "on his own post" do
      it { expect { model.vote_up(user) }.to_not change{ model.votes.sum(:value) }}
    end

    # Повторное голосование работает как отмена голоса
    context "when previously voted up" do
      let!(:vote_prev) { create(:vote, value: 1, votable: model, user: user_other) }
      it { expect { model.vote_up(user_other) }.to change{ model.votes.sum(:value) }.by(-1) }
    end

    context "when previously voted down" do
      let!(:vote_prev) { create(:vote, value: -1, votable: model, user: user_other) }
      it { expect { model.vote_up(user_other) }.to change{ model.votes.sum(:value) }.by(2) }
    end
  end

  describe '#vote_down' do
    let(:user)       { create(:user) }
    let(:user_other) { create(:user) }
    let(:model)      { create(described_class.to_s.underscore.to_sym, user: user) }
    
    context "on other user's post" do
      it { expect { model.vote_down(user_other) }.to change{ model.votes.sum(:value) }.by(-1) }
    end

    context "on his own post" do
      it { expect { model.vote_down(user) }.to_not change{ model.votes.sum(:value) }}
    end

    # Повторное голосование работает как отмена голоса
    context "when previously voted down" do
      let!(:vote_prev) { create(:vote, value: -1, votable: model, user: user_other) }
      it { expect { model.vote_down(user_other) }.to change{ model.votes.sum(:value) }.by(1) }
    end

    context "when previously voted up" do
      let!(:vote_prev) { create(:vote, value: 1, votable: model, user: user_other) }
      it { expect { model.vote_down(user_other) }.to change{ model.votes.sum(:value) }.by(-2) }
    end
  end
end
