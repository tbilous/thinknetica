require 'rails_helper'
RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let (:questions) { create_list(:question, 2) }
    before do
      get :index
    end
    it 'list all' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end
end
