require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      sign_up
      user_creates_restaurant
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_up
      user_creates_restaurant
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_up
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

  end

  context 'viewing restaurants' do

    scenario 'lets a user view a restaurant' do
      sign_up
      user_creates_restaurant
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content 'Deep fried goodness'
    end
  end

  context 'editing restaurants' do
    scenario 'let a user edit a restaurant' do
      sign_up
      user_creates_restaurant
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Chicken'
      click_button 'Update Restaurant'
      click_link 'Kentucky Fried Chicken'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Chicken'
    end
    scenario 'users cannot edit restaurants belonging to other users' do
      sign_up
      user_creates_restaurant
      click_link('Sign out')
      sign_up_user2
      expect(current_path).to eq '/'
      click_link 'Edit KFC'
      expect(page).to have_content "You cannot edit someone else's restaurant"
    end
  end

  context 'deleting restaurants' do

    before { Restaurant.create name: 'KFC', description: 'Deep fried goodness' }

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up
      user_creates_restaurant
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context 'needs a user' do
    scenario 'to use restaurant methods' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
      expect(current_path).to eq '/users/sign_in'
    end
  end

end
