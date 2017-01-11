require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create(name: 'KFC', id: 1) }

  scenario 'allows users to leave a review using a form' do
    sign_up
    # p current_user
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    click_link 'KFC'
    expect(current_path).to eq '/restaurants/1'
    expect(page).to have_content('so so')
  end
end
