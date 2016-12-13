class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Date.yesterday...Date.today)
    mail(to: user.email, subject: 'Daily digest')
  end
end
