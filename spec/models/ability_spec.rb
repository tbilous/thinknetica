require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end


  describe 'for user' do
    include_context 'users'

    let(:user_question) { create(:question, user: user) }
    let(:user_answer) { create(:answer, user: user) }
    let(:john_question) { create(:question, user: john) }
    let(:john_answer) { create(:answer, user: john) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }


    context 'update' do
      it { should be_able_to :update, user_question }
      it { should_not be_able_to :update, john_question }
      it { should be_able_to :update, user_answer }
      it { should_not be_able_to :update, john_answer }
    end

    context 'destroy' do
      it { should be_able_to :destroy, user_question }
      it { should_not be_able_to :destroy, john_question }
      it { should be_able_to :destroy, user_answer }
      it { should_not be_able_to :destroy, john_answer }
    end

    context 'assign_best' do
      it { should be_able_to :assign_best, create(:answer, question: user_question) }
      it { should_not be_able_to :assign_best, create(:answer, question: john_question) }
    end

    context 'vote_plus question' do
      it { should be_able_to :vote_plus, john_question }
      it { should_not be_able_to :vote_plus, user_question }
    end
    context 'vote_minus question' do
      it { should be_able_to :vote_minus, john_question }
      it { should_not be_able_to :vote_minus, user_question }
    end

    context 'vote_cancel question' do
      it { should be_able_to :vote_cancel, john_question }
      it { should_not be_able_to :vote_cancel, user_question }
    end

    context 'vote_plus answer' do
      it { should be_able_to :vote_plus, create(:answer) }
      it { should_not be_able_to :vote_plus, user_answer }
    end

    context 'vote_minus answer' do
      it { should be_able_to :vote_minus, create(:answer) }
      it { should_not be_able_to :vote_minus, user_answer }
    end

    context 'vote_cancel answer' do
      it { should be_able_to :vote_cancel, create(:answer) }
      it { should_not be_able_to :vote_cancel, user_answer }
    end

    context 'destroy attachments' do
      it { should be_able_to :destroy, user_question.attachments.build }
      it { should_not be_able_to :destroy, john_question.attachments.build }
    end
  end
end
