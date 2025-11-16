require_relative "../../helpers/notification_helper"
include Notification_Helper

post "/admin-private/withdraw-requests" do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  if params["request_id"].nil? then
    redirect '/dashboard'
  elsif params["action"].nil?
    then redirect '/dashboard'
  end

  @user = Admins.where(session_token: session["session_token"]).first

  withdrawal_request = UserWithdrawalRequests.where(withdrawal_id: params["request_id"]).first
  action = params["action"]

  # Get request from requests table
  primary_user = Users.where(id: withdrawal_request.primary_user_id).first
  secondary_user = Users.where(id: withdrawal_request.secondary_user_id).first
  request = nil

  if primary_user.user_status == "mentor" then
    request = Requests.where(mentor_id: primary_user.id, mentee_id: secondary_user.id).first
  elsif primary_user.user_status == "mentee" then
    request = Requests.where(mentor_id: secondary_user.id, mentee_id: primary_user.id).first
  else
    @errors = "Server Error: User in withdrawal request was not mentor or mentee"
    erb :"secure-area/shared/admin-dashboard"
  end

  #Perform requested action
  if action == "true" then
    # Accept request & send notif to both users
    request.delete
    Notification_Helper.send_notification_by_id(primary_user.id, 
    "Your request to withdraw from " + secondary_user.full_name + " has been accepted.")
    Notification_Helper.send_notification_by_id(secondary_user.id, 
    primary_user.full_name + "'s request to withdraw from you has been accepted.")
    withdrawal_request.delete

    Notification_Helper.add_admin_event("A withdrawal request from " + 
    primary_user.full_name + " was accepted.")

    redirect '/dashboard'

  elsif action == "false" then
    # Deny request & send notif to the requesting user
    Notification_Helper.send_notification_by_id(primary_user.id, 
    "Your request to withdraw from " + secondary_user.full_name + " has been denied.")
    withdrawal_request.delete

    Notification_Helper.add_admin_event("A withdrawal request from " + 
    primary_user.full_name + " was denied.")

    redirect '/dashboard'

  elsif action == "query" then
    @primary_user = primary_user.full_name
    @secondary_user = secondary_user.full_name
    @withdrawal_request = withdrawal_request
    erb :"/secure-area/admin/withdrawal-requests/view-reasoning"
  else
    redirect '/dashboard'
    puts "Error: /admin-private/withdraw-requests was passed a bad action"
  end
end
