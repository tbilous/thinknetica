feature 'Add comments', %q{
  In order to add comments for question
  All user on question page see comment after his added
} do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:comment_attrib) { attributes_for(:comment) }

  context 'as User' do
    background do
      login_as(user)
      visit question_path(question)
    end

    scenario 'user is authorized', :aggregate_failures do

      within '.question-block' do
        page.find("#addcomment-question-#{question.id}").click

        fill_in 'comment_body', with: comment_attrib[:title]
        click_on 'submit'

        expect(page).to have_content comment_attrib[:body]
      end

    end


    scenario 'user is not authorized', :aggregate_failures do
      within '.question-block' do
        expect(page).to_not have_css("#addcomment-question-#{question.id}")
      end
    end

  end
end