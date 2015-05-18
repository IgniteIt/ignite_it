require 'rails_helper'

feature 'projects' do
  context 'no projects have been added' do
    scenario 'page should have a title' do
      visit '/'
      expect(page).to have_title('Ignite')
    end
  end
end