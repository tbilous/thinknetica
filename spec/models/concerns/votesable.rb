# rate
# set_plus(user)
# set_minus(user)
# vote_cancel(user)
# had_voted(user)

require 'rails_helper'

shared_examples 'votesable' do
  let(:user) { create(:user) }
  let!(:john) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

  describe '#rate' do
    context 'when positive' do
      before { 2.times { create(:vote, challenge: 1, votesable: model, user: create(:user)) } }

      it { expect(model.rate).to eq(2) }
    end

    context 'when negative' do
      before { 2.times { create(:vote, challenge: -1, votesable: model, user: create(:user)) } }

      it { expect(model.rate).to eq(-2) }
    end
  end

  describe '#add_positive' do
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    context 'have negative vote' do
      let!(:vote) { create(:vote, challenge: -1, votesable: model, user: john) }

      it { expect { model.add_positive(john) }.to change { model.rate }.by(2) }
    end

    context 'have positive vote' do
      let!(:vote) { create(:vote, challenge: 1, votesable: model, user: john) }

      it { expect { model.add_positive(john) }.to_not change { model.rate } }
    end

    context 'no previous vote' do
      it { expect { model.add_positive(john) }.to change { model.rate }.by(1) }
    end
  end

  describe '#add_negative' do
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

    context 'have negative vote' do
      let!(:vote) { create(:vote, challenge: -1, votesable: model, user: john) }
      it { expect { model.add_negative(john) }.to_not change { model.rate } }
    end

    context 'have positive vote' do
      let!(:vote) { create(:vote, challenge: 1, votesable: model, user: john) }

      it { expect { model.add_negative(john) }.to change { model.rate }.by(-2) }
    end

    context 'no previous vote' do
      it { expect { model.add_negative(john) }.to change { model.rate }.by(-1) }
    end
  end

  describe '#had_voted?' do
    before { create(:vote, challenge: 1, votesable: model, user: user) }

    it { expect(model.had_voted?(user)).to be true }
  end

  describe '#vote_cancel' do
    before do
      create(:vote, challenge: 1, votesable: model, user: john)
      model.vote_cancel(john)
    end

    it { expect(model.votes.find_by(user: john)).to be_nil }
  end
end
