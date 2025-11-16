
require_relative "../db/db_test"
require_relative "spec_helper"

# CLEAR TEST db
spec_before

# ___________________________________________________________________________

# INTEGRATION TEST TO SEE IF A SIGNED UP ADMIN CAN LOGIN WITH CORRECT DETAILS
# ___________________________________________________________________________

RSpec.describe "Admin logging in" do
  context "When admin has correctly entered login details" do
    it "The current page is checked to see if they have been correctly redirected to the admin dashboard" do
      
      # Create Admin
      admin = Admins.new
      admin.id = 1
      admin.email = "test@gmail.com"
      admin.changed_password = 1
      admin.password = Login_Helper.hash_password("Password1!")
      admin.save

      # Input test details
      visit "/admin-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "Password1!"
      save_page
      click_on "Login"
      
      # Check current page to see if user has been successfully redirected
      expect(current_path).to eq('/dashboard')

    end
  end
end

# ______________________________________________________________________________



# ___________________________________________________________________________________________________

# INTEGRATION TEST TO SEE IF A SIGNED UP ADMIN CAN LOGIN WITH INCORRECT USERNAME BUT CORRECT PASSWORD
# ___________________________________________________________________________________________________

  RSpec.describe "Admin failing to log in" do
    context "When admin has entered an incorrect username but correct password" do
      it "The current page is checked to see if the admin has successfully stayed on the login screen" do
      
      # Input test details
      visit "/admin-login"
      fill_in "email", with: "wrong@gmail.com"
      fill_in "password", with: "Password1!"

      click_on "Login"
      
      # Check current page to see if user has been successfully redirected
      expect(current_path).to eq('/admin-login')

    end
  end
end

# ___________________________________________________________________________________________________



# ___________________________________________________________________________________________________

# INTEGRATION TEST TO SEE IF A SIGNED UP ADMIN CAN LOGIN WITH INCORRECT PASSWORD BUT CORRECT USERNAME
# ___________________________________________________________________________________________________

RSpec.describe "Admin failing to log in" do
  context "When admin has entered an incorrect password but correct username" do
    it "The current page is checked to see if the admin has successfully stayed on the login screen" do
      
      # Input test details
      visit "/admin-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "incorrect"

      click_on "Login"
      
      # Check current page to see if user has been successfully redirected
      expect(current_path).to eq('/admin-login')

    end
  end
end

# ____________________________________________________________________________________________________
