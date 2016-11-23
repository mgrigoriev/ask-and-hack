require 'rails_helper'

shared_examples 'votable' do

  let(:user)  { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  describe '#rating' do
    context 'when positive' do
      before { 2.times {create(:vote, value: 1, votable: model, user: create(:user)) } }

      it { expect(model.rating).to eq(2) }
    end

    context 'when negative' do
      before { 2.times {create(:vote, value: -1, votable: model, user: create(:user)) } }

      it { expect(model.rating).to eq(-2) }
    end

    context 'when zero' do
      it { expect(model.rating).to eq(0) }
    end    
  end

  describe '#has_vote_up_from?' do
    context 'when have votes up from given user' do
      before { create(:vote, value: 1, votable: model, user: user) }

      it { expect(model).to have_vote_up_from(user) }
    end

    context 'when have votes down from given user' do
      before { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model).to_not have_vote_up_from(user) }
    end    

    context 'when have votes up from other user' do
      before { create(:vote, value: 1, votable: model, user: create(:user)) }
      
      it { expect(model).to_not have_vote_up_from(user) }
    end

    context 'when doesn\'t have any votes' do
      it { expect(model).to_not have_vote_up_from(user) }
    end
  end

  describe '#has_vote_down_from?' do
    context 'when have votes down from given user' do
      before { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model).to have_vote_down_from(user) }
    end

    context 'when have votes up from given user' do
      before { create(:vote, value: 1, votable: model, user: user) }

      it { expect(model).to_not have_vote_down_from(user) }
    end    

    context 'when have votes down from other user' do
      before { create(:vote, value: -1, votable: model, user: create(:user)) }
      
      it { expect(model).to_not have_vote_down_from(user) }
    end

    context 'when doesn\'t have any votes' do
      it { expect(model).to_not have_vote_down_from(user) }
    end
  end

  describe '#cancel_vote_from' do
    context 'when vote exists' do
      before do
        create(:vote, value: 1, votable: model, user: user)
        model.cancel_vote_from(user)
      end

      it { expect(model.votes.find_by(user: user)).to be_nil }
    end

    context 'when vote doesn\'t exist' do
      before { model.cancel_vote_from(user) }

      it { expect(model.votes.find_by(user: user)).to be_nil }
    end
  end

  describe '#vote_up' do
    let(:model)      { create(described_class.to_s.underscore.to_sym, user: user) }
    let(:user_other) { create(:user) }

    context "when votes at first time" do
      it { expect { model.vote_up(user_other) }.to change{ model.rating }.by(1) }
    end

    context "when previously voted up" do
      before { create(:vote, value: 1, votable: model, user: user_other) }

      it "cancels vote up" do
        expect { model.vote_up(user_other) }.to change{ model.rating }.by(-1)
      end
    end

    context "when previously voted down" do
      before { create(:vote, value: -1, votable: model, user: user_other) }

      it "cancels vote down and votes up" do
        expect { model.vote_up(user_other) }.to change{ model.rating }.by(2)
      end
    end
  end

  describe '#vote_down' do
    let(:model)      { create(described_class.to_s.underscore.to_sym, user: user) }
    let(:user_other) { create(:user) }

    context "when votes at first time" do
      it { expect { model.vote_down(user_other) }.to change{ model.rating }.by(-1) }
    end

    context "when previously voted down" do
      before { create(:vote, value: -1, votable: model, user: user_other) }

      it "cancels vote down" do
        expect { model.vote_down(user_other) }.to change{ model.rating }.by(1)
      end
    end

    context "when previously voted up" do
      before { create(:vote, value: 1, votable: model, user: user_other) }

      it "cancels vote up and votes down" do
        expect { model.vote_down(user_other) }.to change{ model.rating }.by(-2)
      end
    end
  end
end
