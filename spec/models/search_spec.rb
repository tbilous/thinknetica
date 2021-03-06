require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search' do
    %w(question answer comment user).each do |object|
      it "should call search method for the #{object}" do
        expect(object.classify.constantize).to receive(:search).with('')
        Search.search('', object)
      end
    end

    it 'should call global search' do
      expect(ThinkingSphinx).to receive(:search).with('')
      Search.search('', 'all')
    end

    it 'not valid value' do
      expect(ThinkingSphinx).to receive(:search).with('')
      Search.search('', 'not_valid_value')
    end
  end

  describe '.items_for_select' do
    it 'return array' do
      search_options = [
        %w(All all),
        %w(Questions question),
        %w(Answers answer),
        %w(Comments comment),
        %w(Author user)
      ]
      expect(Search.items_for_select).to match_array(search_options)
    end
  end
end
