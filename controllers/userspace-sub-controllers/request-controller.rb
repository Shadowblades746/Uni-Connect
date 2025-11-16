require_if_exist "helpers"
include Notification_Helper

get '/dashboard/requests' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'mentor' and id_type[1] != 'mentee' then
    redirect '/'
  end

  @user = Users.where(session_token: session["session_token"]).first
  if @user.user_status == 'mentor' then
    @requests = Requests.where(mentor_id: @user.id, acceptance_status: 0)
    .order(Sequel.desc(:date), Sequel.desc(:time))

    @accepted_requests = Requests.where(mentor_id: @user.id, acceptance_status: 1)
    .order(Sequel.desc(:date), Sequel.desc(:time))
  else
    @requests = Requests.where(mentee_id: @user.id).where(acceptance_status: 0)
    .order(Sequel.desc(:date), Sequel.desc(:time))

    @accepted_requests = Requests.where(mentee_id: @user.id, acceptance_status: 1)
    .order(Sequel.desc(:date), Sequel.desc(:time))
  end
  erb :"/secure-area/shared/requests"
end

post '/dashboard/requests' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'mentor' and id_type[1] != 'mentee' then
    redirect '/'
  end
  @user = Users.where(session_token: session["session_token"]).first

  id = params["requestid"]
  decision = params["decision"]

  if decision == "accept"
    Requests.first(request_id: id).update(acceptance_status: 1)
  elsif decision == "deny"
    Requests.first(request_id: id).update(acceptance_status: 2)
  end

  redirect "/dashboard/requests" 
end

post '/dashboard/withdraw-request' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'mentor' and id_type[1] != 'mentee' then
    redirect '/'
  end

  @user = Users.where(session_token: session["session_token"]).first
  @withdraw_from = Users.where(id: params["withdraw_from_id"]).first.full_name
  @withdraw_from_id = params["withdraw_from_id"]

  erb :"secure-area/student/withdraw-from-user/withdraw-reasoning"
end

post '/dashboard/withdraw-request/submit' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'mentor' and id_type[1] != 'mentee' then
    redirect '/'
  end
  
  @user = Users.where(session_token: session["session_token"]).first

  withdraw_request = UserWithdrawalRequests.new
  withdraw_request.primary_user_id = @user.id
  withdraw_request.secondary_user_id = params["withdraw_from_id"]
  withdraw_request.reason_from_primary = params["reason"]
  withdraw_request.save

  withdraw_from_user = Users.where(id: params["withdraw_from_id"]).first
  Notification_Helper.send_notification_by_id(@user.id, "Request to withdraw from " + 
  withdraw_from_user.full_name + " sent!")

  redirect '/dashboard/notifications'
end


