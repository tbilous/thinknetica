require 'rails_helper'
require_relative 'concerns/votesable'

RSpec.describe Question, type: :model do
  it_behaves_like 'votesable'

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  describe 'should be run create callback' do
    include_context 'users'
    let(:question) { create(:question, user: user) }

    it 'should be created new subscription' do
      expect { question.run_callbacks(:commit) }.to change { Subscription.count }
    end
  end
end
