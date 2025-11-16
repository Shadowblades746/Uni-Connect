require_relative "../db/db_test"
require_relative "spec_helper"
require_relative "spec_06_functions"

# CLEAR TEST db
spec_before


RSpec.describe "Student applying to mentor" do
  context "student writes and sends application" do
    it "should add new entry to requests" do
      setup_test_one

      Requests.newRequest(1, 2, "hi!")
      expect(Requests.first.mentee_id).to eq(1)
      expect(Users.where(id: 1).first.getMatches).to eq(1)
      expect(Users.where(id: 2).first.getMatches).to eq(1)
    end
  end
end

