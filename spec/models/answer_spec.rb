require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }  
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  describe '#make_best' do
    let(:author)    { create(:user) }    
    let(:question)  { create(:question, user: author) }
    let!(:answer1)  { create(:answer, question: question) } 
    let!(:answer2)  { create(:answer, question: question) }

    context 'when the best answer is not defined' do
      before do
        answer1.make_best
      end

      it { expect(answer1).to be_best }
    end

    context 'when the best answer is already defined' do
      before do
        answer1.update(best: true)
        answer2.make_best
        answer1.reload
      end

      it { expect(answer2).to be_best }
      it { expect(answer1).to_not be_best }      
    end
  end
end
