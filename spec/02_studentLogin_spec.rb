require_relative "../db/db_test"
require_relative "spec_helper"

# _____________________________________________________________________________

# INTEGRATION TEST TO SEE IF A SIGNED UP STUDENT CAN LOGIN WITH CORRECT DETAILS
# _____________________________________________________________________________

RSpec.describe "Student logging in" do
  context "When student has correctly entered login details" do
    it "The current page is checked to see if they have been correctly redirected to the student dashboard" do
      
      # Create User
      visit "/student-signup"
      fill_in "u_card", with: "1234567890"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "Password1!"
      fill_in "first_names", with: "Test"
      fill_in "last_name", with: "Student"
      select "1st Year", from: "year_group" 
      fill_in "date_of_birth", with: "01-01-2000"
      choose "male"
      fill_in "pronouns", with: "He/Him"
      check "termsConditions"

      # Profile picture left to default
      click_on "Sign Up"

      # Input test details
      visit "/student-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "Password1!"

      click_on "Login"
      
      # Check current page to see if user has been successfully redirected
      expect(current_path).to eq('/finish-setup-account')

    end
  end

  context "Mentee finish profile page" do
    it "Redirects to dashboard once fields are filled in" do
      user = Users.new
      user.id = 1
      user.user_status = "mentee"
      user.setup_complete = 0
      user.email = "test@gmail.com"
      user.password = Login_Helper.hash_password("Password1!")
      user.save

      visit '/student-login'
      fill_in "email", with:"test@gmail.com"
      fill_in "password", with: "Password1!"
      click_on "Login"

      expect(current_path).to eq("/finish-setup-account")

      fill_in "edit_bio", with:"Test bio"
      click_on "Submit information"

      expect(current_path).to eq("/dashboard")
    end
  end

  context "Mentee finish profile page" do
    it "Redirects to dashboard once fields are filled in" do
      user = Users.new
      user.id = 1
      user.user_status = "mentor"
      user.setup_complete = 0
      user.email = "test@gmail.com"
      user.password = Login_Helper.hash_password("Password1!")
      user.save

      visit '/student-login'
      fill_in "email", with:"test@gmail.com"
      fill_in "password", with: "Password1!"
      click_on "Login"

      expect(current_path).to eq("/finish-setup-account")

      fill_in "edit_bio", with:"Test bio"
      fill_in "mentee-capacity", with: "2"
      fill_in "edit-availability", with: "Test availability"
      click_on "Submit information"

      expect(current_path).to eq("/dashboard")
    end
  end
end

# ______________________________________________________________________________



# _____________________________________________________________________________________________________

# INTEGRATION TEST TO SEE IF A SIGNED UP STUDENT CAN LOGIN WITH INCORRECT USERNAME BUT CORRECT PASSWORD
# _____________________________________________________________________________________________________

  RSpec.describe "Student failing to log in" do
    context "When student has entered an incorrect username but correct password" do
      it "The current page is checked to see if the student has successfully stayed on the login screen" do
      
      # Input test details
      visit "/student-login"
      fill_in "email", with: "wrong@gmail.com"
      fill_in "password", with: "Password"

      # Save what login page looks like after details are filled in
      save_page

      click_on "Login"
      
      # Check current page to see if user has been successfully redirected
      expect(current_path).to eq('/student-login')

    end
  end
end

# _____________________________________________________________________________________________________



# _____________________________________________________________________________________________________

# INTEGRATION TEST TO SEE IF A SIGNED UP STUDENT CAN LOGIN WITH INCORRECT PASSWORD BUT CORRECT USERNAME
# _____________________________________________________________________________________________________

RSpec.describe "Student failing to log in" do
  context "When student has entered an incorrect password but correct username" do
    it "The current page is checked to see if the student has successfully stayed on the login screen" do
      
      # Input test details
      visit "/student-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "incorrect"

      # Save what login page looks like after details are filled in
      save_page

      click_on "Login"
      
      # Check current page to see if user has been successfully redirected
      expect(current_path).to eq('/student-login')

    end
  end
end

# ______________________________________________________________________________________________________
