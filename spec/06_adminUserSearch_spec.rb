require_relative "../db/db_test"
require_relative "spec_helper"
require_relative "spec_06_functions"
require_relative "spec_functions"

RSpec.describe "User search" do
  context "Try to access search page while logged out" do
    it "Redirects to /" do  
      visit "/admin-private/user-search-page?searchterm=one+test" 
      expect(current_path).to eq('/')
    end
  end
  context "No search input" do
    it "Lists all users" do
      setup_test_one()

      visit "/admin-login" 
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
      
      expect(current_path).to eq('/dashboard')
      
      visit "/admin-private/user-search-page"
      save_page
      expect(page).to have_text("one test")
      expect(page).to have_text("two test")
      expect(page).to have_text("three test")
    end
  end

  context "Search for first name 'one'" do
    it "Only lists the user called 'one test'" do
      setup_test_one()

      visit "/admin-login" 
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page?searchterm=one"
      save_page   
      expect(page).to have_text("one test")
      expect(page).not_to have_text("two test")
      expect(page).not_to have_text("three test")
    end
  end

  context "Search for last name 'one'" do
    it "Only lists the user called 'test one'" do
      setup_test_two()

      visit "/admin-login" 
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page?searchterm=one"
      save_page
      expect(page).to have_text("test one")
      expect(page).not_to have_text("test two")
      expect(page).not_to have_text("test three")
    end
  end

  context "Search for full name 'one test'" do
    it "Only lists the user called 'one test'" do
      setup_test_two()

      visit "/admin-login" 
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page?searchterm=one+test" 
      save_page
      expect(page).to have_text("one test")
      expect(page).not_to have_text("two test")
      expect(page).not_to have_text("three test")
    end
  end

  context "Search for email 'testone@example.com'" do
    it "Only lists the user called 'one test'" do
      setup_test_one()

      visit "/admin-login" 
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page?searchterm=testone@example.com" 
      save_page
      expect(page).to have_text("one test")
      expect(page).not_to have_text("two test")
      expect(page).not_to have_text("three test")
    end
  end
end

RSpec.describe "Performing actions on users" do
  context "Trying to delete the user 'one test'" do
    it "Deletes the user 'one test'" do
      setup_test_one()

      visit "/admin-login" 
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"

      visit "/admin-private/user-search-page"

      find('.delete-btn', match: :first).click
      save_page
      expect(page).not_to have_text("one test")
    end
  end
end

RSpec.describe "Badge Mentor" do
  context "Attempt to give mentor a badge and then remove it" do
    it "Badge = 1 after the first click, and = nil after the second" do
      spec_before
      setup_test_three()

      visit "/admin-login"
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"

      visit "/admin-private/user-search-page"
      find('.badge-btn', match: :first).click
      expect(Users.where(id: 2).first.badge).to eq(1)
      find('.badge-btn', match: :first).click
      expect(Users.where(id: 2).first.badge).to eq(nil)
    end
  end

  context "Attempt to give mentee a badge" do
    it "Does not give the mentee the badge" do
      spec_before
      setup_test_four()

      visit "/admin-login"
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page"
      find('.badge-btn', match: :first).click
      expect(Users.where(id: 2).first.badge).to eq(nil)
    end
  end
end

RSpec.describe "Flag Users" do
  context "Attempt to flag a user" do
    it "Sets flagged to 1, and has the reason stored in flagged_reason" do
      spec_before
      setup_test_four()

      visit "/admin-login"
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page"
      find('.flag-btn', match: :first).click
      save_page
      fill_in "reason", with: "test reason"

      click_on "Flag User"
      expect(Users.where(id: 2).first.flagged).to eq(1)
      expect(Users.where(id: 2).first.flagged_reason).to eq("test reason")
    end
  end

  context "Attempt to unflag a user" do
    it "Sets flagged to nil and reason to nil" do
      spec_before
      setup_test_four()

      visit "/admin-login"
      fill_in "email", with: "admin@example.com"
      fill_in "password", with: "test"
      click_on "Login"
  
      visit "/admin-private/user-search-page"
      find('.flag-btn', match: :first).click
      save_page
      fill_in "Flag Reason", with: "test reason"
      click_on "Flag User"

      visit "/admin-private/flagged-users"
      save_page
      find('.btn-unflag', match: :first).click

      expect(Users.where(id: 2).first.flagged).to eq(nil)
      expect(Users.where(id: 2).first.flagged_reason).to eq(nil)
    end
  end
end
      
