require_relative "../../db/db_test"
require_relative "../spec_helper"
require_relative "../../helpers/notification_helper"
include Notification_Helper

RSpec.describe Notification_Helper do

  # Note, a user must exist for notifications functions to be tested
  # since the db requires referential integrity for foreign keys, which cannot be mark_admin_event_viewed
  # if a user with the correct id does not exist

  describe "#send_notification_by_id" do
    context "Passed a non existant user_id" do
      it "Returns an error" do
        spec_before
        expect(send_notification_by_id(1,"Text")).to eq(false)
      end
    end

    context "Passed a valid user_id" do
      it "Inserts the notification to the database" do
        spec_before

        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.first_names = "test"
        user.last_name = "name"
        user.user_status = "mentee"
        user.id = 1
        user.setup_complete = 1
        user.password = Login_Helper.hash_password("test")
        user.save
        
        expect(send_notification_by_id(1,"test notif")).to eq(true)
        expect(Notifications.where(id: 1).count).to eq(1)

        visit "/student-login"
        fill_in "email", with: "test@example.com"
        fill_in "password", with: "test"
        click_on "Login"
        click_on "Notifications"
        expect(page).to have_text("test notif")
      end
    end
  end

  describe "#mark_notification_as_read" do
    context "Two notifications in db for user_id 1" do
      it "Sets notification_read to 1 for the first notification only" do
        spec_before

        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.first_names = "test"
        user.last_name = "name"
        user.user_status = "mentee"
        user.id = 1
        user.setup_complete = 1
        user.password = Login_Helper.hash_password("test")
        user.save

        send_notification_by_id(1, "TestOne")
        send_notification_by_id(1, "TestTwo")
        
        visit "/student-login"
        fill_in "email", with: "test@example.com"
        fill_in "password", with: "test"
        click_on "Login"
        click_on "Notifications"
        find('.mark-read', match: :first).click

        expect(Notifications.where(notification_read: 0).count).to eq(1)
        expect(Notifications.where(notification_read: 1).count).to eq(1)
      end
    end
  end

  describe "#mark_all_notifications_as_read" do
    context  do
      it "Sets notifications for user_id to read, but no other users" do
        spec_before

        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.id = 1
        user.save

        user = Users.new
        user.email = "test2@example.com"
        user.id = 2
        user.save

        send_notification_by_id(1, "TestOne")
        send_notification_by_id(1, "TestTwo")
        send_notification_by_id(2, "TestThree")
        
        # First notif id is not neccessarily 1 as AUTOINCREMENT
        # does not reset to zero when the dataset is cleared
        mark_all_notifications_as_read(1)

        expect(Notifications.where(notification_read: 1, id: 1).count).to eq(2)
        expect(Notifications.where(notification_read: 0, id: 1).count).to eq(0)
        expect(Notifications.where(notification_read: 0, id: 2).count).to eq(1)
      end
    end
  end

  describe "#human_readable_date" do
    context "Passed date in yyyy-mm-dd format" do
      it "Returns a date int dd/mm/yyyy format" do
        expect(human_readable_date("2025-03-21")).to eq("21/03/2025")
      end
    end
    context "Notifications.date_time" do
      it "Returns 'date' at 'time" do
        notif = Notifications.new
        notif.date = "2000-01-01"
        notif.time = "12:30"
        notif.notification_id = 99
        notif.save
        expect(Notifications.where(notification_id: 99).first.date_time).to eq("01/01/2000 at 12:30")
      end
    end
  end

  describe "#get_unread_notification_count" do
    context "One unread notification. Only notification in db" do
      it "Returns 1" do
        spec_before

        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.id = 1
        user.save

        Notification_Helper.send_notification_by_id(1,"test")

        expect(Notification_Helper.get_unread_notification_count(1)).to eq(1)
      end
    end

    context "2 users, all 3 notifications for each are unread" do
      it "Return 3 for both users" do
        spec_before

        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.id = 1
        user.save

        user = Users.new
        user.email = "test2@example.com"
        user.id = 2
        user.save

        Notification_Helper.send_notification_by_id(1,"test")
        Notification_Helper.send_notification_by_id(1,"test")
        Notification_Helper.send_notification_by_id(1,"test")
        Notification_Helper.send_notification_by_id(2,"test")
        Notification_Helper.send_notification_by_id(2,"test")
        Notification_Helper.send_notification_by_id(2,"test")

        expect(Notification_Helper.get_unread_notification_count(1)).to eq(3)
        expect(Notification_Helper.get_unread_notification_count(2)).to eq(3)
      end
    end

    context "No notifications in db" do
      it "Return 0" do
        spec_before
        
        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.id = 1
        user.save

        expect(Notification_Helper.get_unread_notification_count(1)).to eq(0)
      end
    end

    context "No unread notifications for user 1" do
      it "Return 0" do
        spec_before

        # Create a new user for testing
        user = Users.new
        user.email = "test@example.com"
        user.id = 1
        user.save

        Notification_Helper.send_notification_by_id(1,"test")
        Notification_Helper.mark_all_notifications_as_read(1)

        expect(Notification_Helper.get_unread_notification_count(1)).to eq(0)
      end
    end
  end
end