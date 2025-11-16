class Requests < Sequel::Model
  require_relative "../helpers/notification_helper"
  include Notification_Helper
  def date_time
    "#{human_readable_date(date)} at #{time}"
  end

  def self.newRequest(mentee_id, mentor_id, application_text)
    newReq = Requests.new
    newReq.mentee_id = mentee_id
    newReq.mentor_id = mentor_id
    newReq.application_text = application_text
    current_time = Time.new
    newReq.time = current_time.strftime("%H:%M")
    newReq.date = current_time.strftime("%Y-%m-%d")
    newReq.acceptance_status = 0
    newReq.save_changes
  end
  
end
