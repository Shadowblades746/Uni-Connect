require_relative "../../db/db_test"
require_relative "../spec_helper"
require_relative "../spec_06_functions"

RSpec.describe "Create new request" do
  context "Attempts to use the newRequest function" do
    it "Creates a new request and adds it to the database table" do
      create_new_user(1111, "mentee", "Mentee", "Default")
      create_new_user(9999, "mentor", "Mentor", "Default")
      Requests.newRequest(1111,9999, "hello!")
      expect(Requests.where(mentee_id: 1111).count).to eq(1)
    end
  end
end