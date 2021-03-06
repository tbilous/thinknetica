require 'rails_helper'
require_relative 'concerns/votesable'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votesable'

  it { should validate_presence_of :question_id }
  it { should validate_length_of(:body).is_at_least(6) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe 'set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:other_answer) { create(:answer, question: question, user: user) }

    context 'when the best answer is not defined' do
      before do
        answer.update(best: true)
      end

      it { expect(answer).to be_best }
    end

    context 'when the best answer is already defined' do
      before do
        answer.set_best
        other_answer.set_best
        answer.reload
      end

      it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
      it { expect(other_answer).to be_best }
      it { expect(answer).to_not be_best }
    end
  end

  describe 'subscriptions mailer' do
    include_context 'users'

    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: john, question: question) }

    it 'should queue active job' do
      expect { answer.run_callbacks(:commit) }
        .to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(1)
    end

    it 'should queue active job' do
      expect { answer.run_callbacks(:commit) }.to have_enqueued_job(NewAnswerNotificationJob)
    end
  end
end
