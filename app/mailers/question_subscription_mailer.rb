class QuestionSubscriptionMailer < ApplicationMailer
  def notification_email(user, answer)
    @answer = answer
    mail(to: user.email, subject: "Re: #{@answer.question.title}")
  end
end
