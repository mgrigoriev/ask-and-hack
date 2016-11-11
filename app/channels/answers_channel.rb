class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end  
end