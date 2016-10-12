require 'rails_helper'

RSpec.describe Question, type: :model do
  before do
    @question = Question.new(title: ('a' * 5), body: ('a' * 61))
  end

  subject { @question }

  it { should respond_to(:title) }
  it { should respond_to(:body) }

  it { should be_valid }

  it do
    should validate_presence_of :title
    should validate_length_of(:title)
      .is_at_least(5).is_at_most(128)
  end
  it do
    should validate_presence_of :body
    should validate_length_of(:body)
      .is_at_least(60)
  end
end
