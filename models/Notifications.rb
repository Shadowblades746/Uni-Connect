class Notifications < Sequel::Model
  require_relative "../helpers/notification_helper"
  include Notification_Helper
  def date_time
    "#{human_readable_date(date)} at #{time}"
  end
end