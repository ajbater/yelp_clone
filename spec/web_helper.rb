
def sign_up
  visit '/users/sign_up'
  fill_in 'Email', with: 'user@user.com'
  fill_in 'Password', with: 'password123'
  fill_in 'Password confirmation', with: 'password123'
  click_button 'Sign up'
end
