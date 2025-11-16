require_relative "../../db/db_test"
require_relative "../spec_helper"
require_relative "../spec_06_functions"

RSpec.describe "Users full name" do
  context "Try to get a user's full name from their entry" do
    it "Returns their first names and surname" do
      create_new_user(8877, "mentor", "First", "Last")
      expect(Users.where(id: 8877).first.full_name).to eq("First Last")
    end
  end
end

RSpec.describe "User get matches" do
  context "Attempts to get the number of matches for a user" do
    it "Returns 1 for a single match" do
      create_new_user(1111, "mentee", "Mentee", "Default")
      create_new_user(9999, "mentor", "Mentor", "Default")
      Requests.newRequest(1111,9999, "hello!")
      Requests.where(mentee_id: 1111).first.acceptance_status = 1
      expect(Users.where(id: 1111).first.getMatches).to eq(1)
    end
  end
end
