class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 60 }, presence: true
  validates :question_id, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  default_scope { order('best DESC, created_at DESC') }

  def set_best
    transaction do
      question.answers.where(best: true).each do |answer|
        answer.update!(best: false)
      end
      update!(best: true)
    end
  end
end
