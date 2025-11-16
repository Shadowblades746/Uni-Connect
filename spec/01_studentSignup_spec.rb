
require_relative "../db/db_test"
require_relative "spec_helper"

# CLEAR TEST db
spec_before

# _____________________________________________________________________________________________

# INTEGRATION TEST TO SEE IF SIGNUP CORRECTLY INTERACTS WITH USERS TABLE IN ds.sqlite3 DATABASE
# _____________________________________________________________________________________________

RSpec.describe "Student signing up" do
  context "When student has entered all signup details" do
    it "The Users table is checked to see if the students details have been added" do
      
      # Input test details
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
      
      # Check database to see if student has been added to Users
      expect(Users.where(id: 1234567890).count).to eq(1)

      # Check all student details match (bar password which is now hashed)
      expect(Users.where(id: 1234567890, email: "test@gmail.com").count).to eq(1)
      expect(Users.where(id: 1234567890, first_names: "Test").count).to eq(1)
      expect(Users.where(id: 1234567890, last_name: "Student").count).to eq(1)
      expect(Users.where(id: 1234567890, year_group: "1st").count).to eq(1)
      expect(Users.where(id: 1234567890, date_of_birth: "01-01-2000").count).to eq(1)
      expect(Users.where(id: 1234567890, gender: "male").count).to eq(1)
      expect(Users.where(id: 1234567890, pronouns: "He/Him").count).to eq(1)
    end
  end
end

# _____________________________________________________________________________________________
