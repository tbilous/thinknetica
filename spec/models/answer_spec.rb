require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :question_id }
  it { should validate_length_of(:body).is_at_least(60) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:best).scoped_to(:question_id) }

  describe 'set_best' do
    let(:user)    { create(:user) }
    let(:question)  { create(:question, user: user) }
    let!(:answer1)  { create(:answer, question: question) }
    let!(:answer2)  { create(:answer, question: question) }

    context 'when the best answer is not defined' do
      before do
        answer1.set_best
      end

      it { expect(answer1).to be_best }
    end

    context 'when the best answer is already defined' do
      before do
        answer1.set_best
        answer2.set_best
        answer1.reload
      end

      it { expect(answer2).to be_best }
      it { expect(answer1).to_not be_best }
    end
  end
end
