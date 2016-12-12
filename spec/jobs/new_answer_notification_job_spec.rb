require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do

  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) } # author is subscribed to question
  let(:answer)   { create(:answer, question: question) }

  it 'sends notification' do
    expect(QuestionSubscriptionMailer).to \
      receive(:notification_email).with(user, answer).and_call_original

    NewAnswerNotificationJob.perform_now(answer)
  end
end
