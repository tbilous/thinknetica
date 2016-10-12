require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { FactoryGirl.create(:question) }
  before do
    @answer = Answer.new(body: ('a' * 61), question_id: question.id)
  end

  subject { @answer }

  it { should respond_to(:body) }

  it { should be_valid }

  it 'check attr body' do
    should validate_presence_of :question_id
    should belong_to(:question)
    should validate_length_of(:body).is_at_least(60)
  end

  it 'check dependent destroy' do
    answer = FactoryGirl.build(:answer)
    question.answers << answer
    expect { question.destroy }.to change { Answer.count }.by(-1)
  end
end
