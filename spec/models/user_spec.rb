require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }  
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
end