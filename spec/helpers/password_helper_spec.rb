require_relative "../spec_helper"
require_relative "../../helpers/password_helper"
include Password_Helper

RSpec.describe Notification_Helper do
  describe "#string_contains_number?" do
    
    context "Passed an empty string" do
      it "Returns false" do
        expect(string_contains_number?("")).to eq(false)
        expect(string_contains_number?(" ")).to eq(false)
      end
    end

    context "Passed a non-number character" do
      it "Returns false" do
        expect(string_contains_number?("a")).to eq(false)
      end
    end
    
    context "Passed a single digit" do
      it "Returns true" do
        expect(string_contains_number?("0")).to eq(true)
        expect(string_contains_number?("1")).to eq(true)
        expect(string_contains_number?("2")).to eq(true)
        expect(string_contains_number?("3")).to eq(true)
        expect(string_contains_number?("4")).to eq(true)
        expect(string_contains_number?("5")).to eq(true)
        expect(string_contains_number?("6")).to eq(true)
        expect(string_contains_number?("7")).to eq(true)
        expect(string_contains_number?("8")).to eq(true)
        expect(string_contains_number?("9")).to eq(true)
      end
    end

    context "Passed a series of digits" do
      it "Returns true" do
        expect(string_contains_number?("0123456789876543210")).to eq(true)
      end
    end

    context "Passed a mix of digits and non-number characters" do
      it "Returns true" do
        expect(string_contains_number?("0123abcd")).to eq(true)
      end
    end
  end

  describe "#string_contains_symbol?" do
  
    context "Passed an empty string" do
      it "Returns false" do
        expect(string_contains_symbol?("")).to eq(false)
        expect(string_contains_symbol?(" ")).to eq(false)
      end
    end


    context "Passed a single allowed symbol" do
      it "Returns true" do
        expect(string_contains_symbol?("!")).to eq(true)
        expect(string_contains_symbol?("£")).to eq(true)
        expect(string_contains_symbol?("$")).to eq(true)
        expect(string_contains_symbol?("%")).to eq(true)
        expect(string_contains_symbol?("&")).to eq(true)
        expect(string_contains_symbol?("-")).to eq(true)
        expect(string_contains_symbol?("_")).to eq(true)
        expect(string_contains_symbol?("@")).to eq(true)
        expect(string_contains_symbol?("?")).to eq(true)
      end
    end

    context "Passed a series of allowed symbols" do
      it "Returns true" do
        expect(string_contains_symbol?("!£$%&-_@")).to eq(true)
      end
    end

    context "Passed a mix of allowed symbols and other characters" do
      it "Returns true" do
        expect(string_contains_symbol?("abcd!£")).to eq(true)
      end
    end

    context "Passed a string with no allowed symbols" do
      it "Returns false" do
        expect(string_contains_symbol?("abcd")).to eq(false)
      end
    end
  end

  describe "#string_contains_disallowed_symbol?" do

    context "Passed an empty string" do
      it "Returns false" do
        expect(string_contains_disallowed_symbol?("")).to eq(false)
        expect(string_contains_disallowed_symbol?("")).to eq(false)
      end
    end

    context "Passed a string with a single disallowed symbol" do
      it "Returns true" do
        expect(string_contains_disallowed_symbol?("<")).to eq(true)
        expect(string_contains_disallowed_symbol?(">")).to eq(true)
        expect(string_contains_disallowed_symbol?("\\")).to eq(true)
        expect(string_contains_disallowed_symbol?("/")).to eq(true)
        expect(string_contains_disallowed_symbol?("|")).to eq(true)
        expect(string_contains_disallowed_symbol?(":")).to eq(true)
        expect(string_contains_disallowed_symbol?(";")).to eq(true)
        expect(string_contains_disallowed_symbol?("'")).to eq(true)
        expect(string_contains_disallowed_symbol?('"')).to eq(true)
        expect(string_contains_disallowed_symbol?("^")).to eq(true)
        expect(string_contains_disallowed_symbol?("(")).to eq(true)
        expect(string_contains_disallowed_symbol?(")")).to eq(true)
        expect(string_contains_disallowed_symbol?("*")).to eq(true)
        expect(string_contains_disallowed_symbol?("+")).to eq(true)
        expect(string_contains_disallowed_symbol?("=")).to eq(true)
        expect(string_contains_disallowed_symbol?("`")).to eq(true)
        expect(string_contains_disallowed_symbol?("¬")).to eq(true)
        expect(string_contains_disallowed_symbol?("[")).to eq(true)
        expect(string_contains_disallowed_symbol?("]")).to eq(true)
      end
    end

    context "Passed multiple disallowed symbols" do
      it "Returns true" do
        expect(string_contains_disallowed_symbol?("+=/;:<")).to eq(true)
      end
    end

    context "Passed string with no disallowed symbols" do
      it "Returns false" do
        expect(string_contains_disallowed_symbol?("abcd1234!£$@")).to eq(false)
      end
    end
  end
  

  describe "#secure_password?" do

    context "Passed an empty string" do
      it "Returns false" do
        expect(secure_password?("")).to eq(false)
        expect(secure_password?(" ")).to eq(false)
      end
    end

    context "Passed a too short password, but otherwise valid" do
      it "Returns false" do
        expect(secure_password?("ab12!?")).to eq(false)
      end
    end

    context "Passed a password with no allowed special characters, but otherwise valid" do
      it "Returns false" do
        expect(secure_password?("abcdef123456")).to eq(false)
      end
    end

    context "Passed a password with no numbers, but otherwise valid" do
      it "Returns false" do
        expect(secure_password?("abcdef!£$%&")).to eq(false)
      end
    end

    context "Passed a password with a disallowed symbol, but otherwise valid" do
      it "Returns false" do
        expect(secure_password?("abcd1234!£$&;:<>")).to eq(false)
      end
    end

    context "Passed a valid password" do
      it "Returns true" do
        expect(secure_password?("abcddcba1478!£")).to eq(true)
        expect(secure_password?("xyz$98&7_1")).to eq(true)
      end
    end
  end
end