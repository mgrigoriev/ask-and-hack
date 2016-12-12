require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do

  let!(:user) { create(:user) }

  it 'sends daily digest' do
    expect(DailyMailer).to receive(:digest).with(user).and_call_original

    Sidekiq::Testing.fake! { DailyDigestJob.perform_now }
  end
end
