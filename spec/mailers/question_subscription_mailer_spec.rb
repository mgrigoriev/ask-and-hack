require "rails_helper"

describe QuestionSubscriptionMailer do
  describe "notification_email" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { QuestionSubscriptionMailer.notification_email(user, answer) }

    it "renders the subject" do
      expect(mail.subject).to eq("Re: #{answer.question.title}")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content(answer.body)
      expect(mail.body.encoded).to have_link(href: question_url(answer.question))
    end
  end
end
