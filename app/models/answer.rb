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

  # after_create_commit :broadcast

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

  private
  def broadcast
    return if errors.any?

    files = []
    attachments.each { |a| files << { id: a.id, file_url: a.file.url, file_name: a.file.identifier } }

    ActionCable.server.broadcast(
      "answers_#{question_id}",
      answer:             self,
      answer_attachments: files,
      answer_rating:      rate,
      question_user_id:   question.user_id
    )
  end
end
