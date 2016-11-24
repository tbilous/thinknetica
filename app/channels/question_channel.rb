class QuestionChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "answer_#{data['question_id']}"
    stream_from "comment_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end
end
