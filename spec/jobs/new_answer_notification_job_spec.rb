require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do

  let(:users)         { create_list(:user, 2) }
  let(:question)      { create(:question, user: users.first) } # author is auto-subscribed to the question
  let!(:subscription) { create(:subscription, question: question, user: users.second) }
  let(:answer)        { create(:answer, question: question) }

  it 'sends notification' do
    users.each do |user|
      expect(QuestionSubscriptionMailer).to \
        receive(:notification_email).with(user, answer).and_call_original
    end

    Sidekiq::Testing.fake! { NewAnswerNotificationJob.perform_now(answer) }
  end
end
