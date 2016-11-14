require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:author)   { create(:user) }
    let(:stranger) { create(:user) }  
    let(:question) { create(:question, user: author) }
    let(:answer)   { create(:answer, question: question, user: author) }

    context "when user is the question's author" do
      it { expect(author).to be_author_of(question) }
    end

    context "when user is the answer's author" do
      it { expect(author).to be_author_of(answer) }
    end

    context "when user is not the question's author" do
      it { expect(stranger).to_not be_author_of(question) }
    end

    context "when user is not the answer's author" do
      it { expect(stranger).to_not be_author_of(answer) }
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user already has no authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: user.email} ) }
        it 'does not create new user' do
          expect {User.find_for_oauth(auth)}.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect {User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@example.com'} ) }
        it 'creates new user' do
          expect {User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
