require_relative "../db/db_test"
require_relative "spec_helper"
require_relative "spec_06_functions"

RSpec.describe("Logout") do
  context "Navigate to logout page" do
    it "Clears the session, so cannot visit dashboard" do
      create_new_user(1,"mentee","NameA", "NameB")
      visit "/student-login"
      fill_in "email", with: "NameBNameA@example.com"
      fill_in "password", with: "password"
      click_on "Login"

      visit "/logout"
      expect(current_path).to eq("/logout")
      visit "/dashboard"
      expect(current_path).to eq("/")
    end
  end
end