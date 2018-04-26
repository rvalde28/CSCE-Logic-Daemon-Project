def create_visitor
  @visitor ||= { :nickname => "Tester McUserton" }
end

def create_anon
  @anon ||= { :nickname => "Anonymous" }
end

def find_user
  @user ||= User.where(:nickname => @visitor[:nickname]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_in
  visit 'logic/quizmaster'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, @visitor)
end

def delete_user
  @user ||= User.where(:nickname => @visitor[:nickname])
  @user.destroy unless @user.nil?
end

def sign_in
  visit 'logic/quizmaster'
  fill_in "nickname", :with => @visitor[:nickname]
  click_button "Sign in"
  find_user
end

### GIVEN ###
Given (/^user is not logged in$/) do
  visit 'logic/quizmaster'
end

Given (/^user is logged in$/) do
  create_user
  sign_in
end

### WHEN ###
When (/^user signs in with valid credentials$/) do
  create_visitor
  sign_in
end

When (/^user signs in with anonymous$/) do
  create_anon
  sign_in
end

When (/^user returns to the site$/) do
  visit 'logic/quizmaster'
end

When (/^user signs in with invalid credentials$/) do
  @visitor = @visitor.merge(:nickname => "")
  sign_in
end

### THEN ###
Then (/^user should be signed in$/) do
  page.should_not have_content "Login"
  page.should have_content "Logout"
end

Then (/^user should be signed out$/) do
  page.should have_content "Login"
  page.should_not have_content "Logout"
end

Then (/^user should see a successful sign in message$/) do
  page.should have_content "Signed in successfully."
end

Then (/^user should see a signed out message$/) do
  page.should have_content "Signed out successfully."
end

Then (/^user should see an invalid login message$/) do
  page.should have_content "Invalid nickname."
end
