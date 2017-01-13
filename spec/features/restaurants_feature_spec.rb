require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      sign_up

      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurant have been added' do
    before do
      sign_up
      create_restaurant
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Subway')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do


    scenario 'user has to be logged in to add restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
    end

    context 'user is logged in' do

      before do
        sign_up
      end

      scenario 'prompts user to fill out a form, the displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'Subway'
        click_button 'Create Restaurant'
        expect(page).to have_content 'Subway'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'user can upload an image of the restaurant' do
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'Subway'
        fill_in 'Description', with: 'Sandwiches'
        attach_file('restaurant_image', File.absolute_path('./public/images/000/000/002/thumb/missing.png'))
        click_button 'Create Restaurant'
        assert page.has_xpath?('/html/body/img')
        # assert page.has_xpath?("//img[@alt='/system/restaurants/images/000/000/003/thumb/missing.png?1484317956' and @src = 'missing']")
      end

      context 'an invalid restaurant' do
        scenario 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end

    context 'editing restaurants' do
      context 'logged in' do

        before do
          sign_up
          p current_path
          create_restaurant
        end

        scenario 'let a user edit a restaurant' do
          visit '/restaurants'
          click_link 'Edit Subway'
          fill_in 'Name', with: 'KFC'
          fill_in "Description", with: 'quite a change really'
          click_button 'Update Restaurant'
          expect(page).to have_content 'KFC'
          expect(page).to have_content 'quite a change really'
          expect(current_path).to eq '/restaurants'
        end
      end

      context 'deleting restaurants' do
        before do
          sign_up
          create_restaurant
        end

        scenario 'removes a restaurant when a user clicks a delete link' do
          visit '/restaurants'
          click_link 'Delete Subway'
          expect(page).not_to have_content 'Subway'
          expect(page).to have_content 'Restaurant deleted successfully'
        end
      end
    end
  end

  context 'viewing restaurants' do
    before do
      sign_up
      create_restaurant
      click_link "Sign out"
    end

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'Subway'
      expect(page).to have_content 'Subway'
      subway = Restaurant.first
      expect(current_path).to eq "/restaurants/#{subway.id}"
    end
  end
  context 'not signed in' do
    before do
      user = User.create(email: "test@test.com", password: "testtest")
      user.restaurants.create(name: "Subway")
    end

    scenario 'users can only edit restaurants they created' do
      sign_up
      click_link 'Edit Subway'
      expect(current_path).to eq '/'
      expect(page).to have_content('You must have created this restaurant to do this')
    end

    scenario 'users can only delete restaurants they created' do
      sign_up
      click_link 'Delete Subway'
      expect(current_path).to eq '/'
      expect(page).to have_content('You must have created this restaurant to do this')
    end
  end
end
