require_relative "../db/db_test"
require_relative "spec_helper"


RSpec.describe "Student Account Deletion" do
  context "When student selects account deletion and confirms deletion" do
    it "The Users table is checked to see if their account has been successfully deleted" do
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
      
      # Log in
      visit "/student-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "Password1!"

      click_on "Login"

      visit "/dashboard/settings"

      click_on "Delete Account"
      # Check successfully redirected to delete account page
      expect(current_path).to eq('/dashboard/delete-account')

      fill_in "password", with: "Password1!"
      fill_in "repeat_password", with: "Password1!"
      click_on "Confirm Account Deletion"
            
      # Check Users table to confirm successfull deletion
      expect(Users.where(id: 1234567890).count).to eq(0)
      # Check successfully redirected to successfull account deletion page
      expect(current_path).to eq('/account-deleted')

    end
  end
end

RSpec.describe "Student Account Failed Deletion" do
  context "When student selects account deletion and inputs the wrong password" do
    it "The Users table is checked to see if their account hasn't been deleted" do
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
      
      # Log in
      visit "/student-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "Password1!"

      click_on "Login"

      visit "/dashboard/settings"

      click_on "Delete Account"
      # Check successfully redirected to delete account page
      expect(current_path).to eq('/dashboard/delete-account')

      fill_in "password", with: "Password2!"
      fill_in "repeat_password", with: "Password2!"
      click_on "Confirm Account Deletion"
            
      # Check Users table to confirm successfull deletion
      expect(Users.where(id: 1234567890).count).to eq(1)

    end
  end
end

RSpec.describe "Student Account Failed Deletion, mismatch" do
  context "When student selects account deletion and inputs mismatched passwords" do
    it "The Users table is checked to see if their account hasn't been deleted" do
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
      
      # Log in
      visit "/student-login"
      fill_in "email", with: "test@gmail.com"
      fill_in "password", with: "Password1!"

      click_on "Login"

      visit "/dashboard/settings"

      click_on "Delete Account"
      # Check successfully redirected to delete account page
      expect(current_path).to eq('/dashboard/delete-account')

      fill_in "password", with: "Password1!"
      fill_in "repeat_password", with: "Password2!"
      click_on "Confirm Account Deletion"
            
      # Check Users table to confirm successfull deletion
      expect(Users.where(id: 1234567890).count).to eq(1)

    end
  end
end
