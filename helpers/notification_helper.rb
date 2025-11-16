module Notification_Helper

  require 'sequel'
  require_relative './validation'
  include Validation
  include Sequel

  def send_notification_by_id(input_id, notification_text)

    return false if Users.where(id: input_id).first.nil?

    current_time = Time.new
    time_string = current_time.strftime('%H:%M')
    date_string = current_time.strftime('%Y-%m-%d')
    Notifications.insert(id: input_id, text: notification_text, date: date_string, time: time_string, notification_read: 0)
    true
  end

  # Get the number of unread notifications for the specified user
  def get_unread_notification_count(input_id)
    return Notifications.where(id: input_id, notification_read: 0).count
  end

  def mark_notification_as_read(input_notification_id)
    notif = Notifications.where(notification_id: input_notification_id).first
    return false if notif.nil?

    notif.update(notification_read: 1)
    notif.save
    true
  end

  def mark_all_notifications_as_read(input_id)
    Notifications.where(id: input_id).each do |notif|
      notif.update(notification_read: 1)
      notif.save
    end
  end

  def human_readable_date(raw_date)
    return nil unless raw_date.is_a?(String)

    return nil unless str_yyyy_mm_dd_date?(raw_date)

    split_date = raw_date.split('-')
    "#{split_date[2]}/#{split_date[1]}/#{split_date[0]}"
  end

  def add_admin_event(event_text)
    current_time = Time.new
    time_string = current_time.strftime('%H:%M')
    date_string = current_time.strftime('%Y-%m-%d')

    AdminActivity.insert(event_text: event_text, event_date: date_string, event_time: time_string, event_viewed: 0)
  end

  def mark_admin_event_viewed(event_id)
    AdminActivity.where(event_id: event_id).update(event_viewed: 1)
  end

  def mark_all_admin_event_viewed
    AdminActivity.where(event_viewed: 0).update(event_viewed: 1)
  end

  def get_not_viewed_event_count
    AdminActivity.where(event_viewed: 0).count
  end
end
