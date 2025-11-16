
require_relative "../db/db_test"
require_relative "spec_helper"

# _____________________________________________________________________________________________________

# INTEGRATION TEST TO SEE IF SIGNUP CORRECTLY INTERACTS WITH ADMINACTIVITY TABLE IN ds.sqlite3 DATABASE
# _____________________________________________________________________________________________________

RSpec.describe "Admin signing up" do
  context "When admin has entered all signup details" do
    it "The Admins table is checked to see if the students details have been added" do
      
      # Input test details
      visit "/admin-signup"
      fill_in "email", with: "test@gmail.com"
      fill_in "extra_info", with: "NA"

      click_on "Sign Up"
      
      # Check activity to see if the new admin signup has been noted
      expect(AdminActivity.where(event_text: "test@gmail.com signed up as an admin.\nExtra info: NA").count).to eq(1)
    end
  end
end

# _____________________________________________________________________________________________________
