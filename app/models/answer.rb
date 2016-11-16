class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Formatted

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votesable, dependent: :destroy

  validates :body, length: { minimum: 60 }, presence: true
  validates :question_id, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  default_scope { order('best DESC, created_at DESC') }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def set_best
    transaction do
      question.answers.where(best: true).each do |answer|
        answer.update!(best: false)
      end
      update!(best: true)
    end
  end
end
