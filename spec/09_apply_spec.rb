require_relative "../db/db_test"
require_relative "spec_helper"
require_relative "spec_functions"
require_relative "spec_06_functions"

spec_before

RSpec.describe "Apply" do
  context "Access apply routes while logged out" do
    it "Redirects to dashboard" do    
      visit '/dashboard/apply'
      expect(current_path).to eq("/")
  
      visit '/dashboard/report'
      expect(current_path).to eq("/")

      visit '/dashboard/profile-page'
      expect(current_path).to eq("/")
    end
  end
end

RSpec.describe "View Profile" do
  context "Navigate to /profile while logged in" do
    it "Shows the currently logged in users profile" do
      create_new_user(1,"mentee","NameA", "NameB")
      visit "/student-login"
      fill_in "email", with: "NameBNameA@example.com"
      fill_in "password", with: "password"
      click_on "Login"
  
      visit '/dashboard/profile-page'
      expect(page).to have_text("NameA NameB")
    end
  end

  context "Navigate to /profile?id=2 while logged in" do
    it "Shows the second users profile" do
      create_new_user(1,"mentee","NameA", "NameB")
      create_new_user(2,"mentee","NameC", "NameD")

      visit "/student-login"
      fill_in "email", with: "NameBNameA@example.com"
      fill_in "password", with: "password"
      click_on "Login"
  
      visit '/dashboard/profile-page?id=2'
      expect(page).to have_text("NameC NameD")
    end
  end

  context "Navigate to /profile while logged out" do
    it "Redirects to /" do
      visit '/dashboard/profile-page?id=2'
      expect(current_path).to eq('/')
    end
  end
end

RSpec.describe "Withdraw from mentee/mentor" do
  context "Mentor withdraw from mentee" do
    it "Removes the match" do
      create_new_admin()
      create_new_user(1,"mentee","NameA", "NameB")
      create_new_user(2,"mentor","NameC", "NameD")
      user = Users.where(id: 2).first
      user.mentee_capacity = 5
      user.mentor_availability = "test"
      user.save

      visit "/student-login"
      fill_in "email", with: "NameCNameD@example.com"
      fill_in "password", with: "password"
      click_on "Login"
      visit "/logout"

      visit "/student-login"
      fill_in "email", with: "NameBNameA@example.com"
      fill_in "password", with: "password"
      click_on "Login"

      save_page

      click_on "Apply"
      fill_in "application_text", with: "Test Apply"
      click_on "Apply"

      visit "/logout"
      visit "/student-login"
      fill_in "email", with: "NameDNameC@example.com"
      fill_in "password", with: "password"
      click_on "Login"

      visit "/dashboard/requests"

      expect(page).to have_text("NameC NameD")

      click_on "Accept" # Accept request
      click_on "Request to Withdraw"
      fill_in "edit-bio", with: "Test"
      save_page
      click_on "Confirm Withdrawal Request"

      visit "/logout"

      # Admin accepts request
      visit "/admin-login"
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
      
      within(".withdraw_request") do
        click_on "Accept"
      end
      save_page

      visit "/logout"
      visit "/student-login"

      fill_in "email", with: "NameDNameC@example.com"
      fill_in "password", with: "password"
      click_on "Login"
      visit "/dashboard/requests"
      expect(page).not_to have_text("NameA NameB")
    end
  end
end