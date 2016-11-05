require 'rails_helper'
require_relative 'concerns/votesable'

RSpec.describe Question, type: :model do
  it_behaves_like 'votesable'

  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(128) }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(60) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }
end
