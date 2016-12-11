require "rails_helper"

describe DailyMailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }
    let!(:question1) { create(:question, title: 'Question 1', created_at: 1.day.ago) }
    let!(:question2) { create(:question, title: 'Question 2', created_at: 1.day.ago) }

    it "renders the subject" do
      expect(mail.subject).to eq("Daily digest")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      [question1, question2].each do |q|
        expect(mail.body.encoded).to have_link(q.title, href: question_url(q))
      end
    end
  end
end
