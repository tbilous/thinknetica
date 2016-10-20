require 'rails_helper'
feature 'Attributes of pages', %q{
  Root page have Home page in title
} do
  scenario 'Root page have title' do
    visit root_path
    expect(page).to have_title 'Home page'
  end
end