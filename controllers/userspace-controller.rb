require_if_exist 'helpers'
include Notification_Helper
include Login_Helper
include Settings_Helper
include UserAdminHelper


get '/finish-setup-account' do
  if session["session_token"].nil? || Users.where(session_token: session["session_token"]).nil?
    redirect "/student-login"
  end

  @user = Users.where(session_token: session['session_token']).first
  @global_max_mentee_capacity = GlobalSettings.first.global_max_mentee_capacity
  @error_message = session.delete("error_message")

  redirect '/student-login' if @user.nil?
  redirect '/dashboard' if @user.setup_complete == 1

  erb :"secure-area/shared/finish-account"
end

post "/finish-account-setup" do
  if session["session_token"].nil? || Users.where(session_token: session["session_token"]).nil?
    redirect "/student-login"
  end

  result = finish_account_setup(params)
  user = Users.where(session_token: session['session_token']).first
  
  if result[:success] || user.setup_complete == 1 then
    redirect "/dashboard"
  else
    session[:error_message]= result[:error]
    redirect "/finish-setup-account"
  end
end


get '/dashboard' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  redirect '/' if id_type.nil?

  if id_type[1] == 'admin'
    @user = Admins.where(id: id_type[0]).first
    if @user.changed_password.nil?
      redirect '/admin-change-password'
    end
    @search_term = params['searchterm'] if !params['searchterm'].nil? || (!params['searchterm'] == '')
    erb :"/secure-area/admin/admin-dashboard"
  else
    @user = Users.where(id: id_type[0]).first

    @mentors = Users.where(user_status: 'mentor')
    redirect '/finish-setup-account' if @user.setup_complete.nil? || @user.setup_complete == 0 #users need a bio for account to be considered complete
    mentorsNotFull = []
    @mentors.each do |mentor| #gets a list of the IDs of all mentors who aren't at capacity
      print(mentor.getMatches)
      if mentor.getMatches < GlobalSettings.first.global_max_mentee_capacity and mentor.getMatches < mentor.mentee_capacity
        mentorsNotFull.append(mentor.id)
      end
    end
    @validMentors = Users.where(id: mentorsNotFull)

    erb :"secure-area/shared/dashboard"
  end
end

get '/dashboard/settings' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil
  @global_max_mentee_capacity = GlobalSettings.first.global_max_mentee_capacity
  @error_message = session.delete("error_message")

  if id_type[1] == 'admin'
    redirect "/dashboard"
  else 
    @user = Users.where(id: id_type[0]).first
    erb :"/secure-area/shared/settings"
  end
end

post '/settings-edit-profile' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 
  result = edit_profile(params)
  if result[:success]
    redirect '/dashboard/settings'
  else
    session[:error_message]= result[:error]
    redirect '/dashboard/settings'
  end
end

post '/settings-edit-personal-information' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 

  result = edit_personal_details(params)
  if result[:success]
    redirect '/dashboard/settings'
  else
    session[:error_message]
    redirect '/dashboard/settings'
  end
  redirect '/dashboard/settings'

end

get '/dashboard/apply' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 

  @user = current_user
  if @user.user_status == 'mentee'
    existing_request = Requests.where(mentee_id: @user.id, acceptance_status: [0, 1]).first
    if existing_request
      Notification_Helper.send_notification_by_id(@user.id, "You already have a mentor or a pending request.")
      redirect '/dashboard'
    end
  end
  @mentor_id = params['mentor_id']
  redirect_to_dashboard if @mentor_id.nil?
  erb :"/secure-area/student/apply"
end

post '/dashboard/send-application' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 

  Requests.newRequest(current_user.id, params['mentor_id'], params['application_text'])
  Notification_Helper.send_notification_by_id(current_user.id, 'Request successfully sent!')
  Notification_Helper.send_notification_by_id(params['mentor_id'], "You've received a new mentee request! Check it out in the requests tab.")
  redirect_to_dashboard
end

get '/dashboard/report' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 

  @user = Users.where(session_token: session['session_token']).first
  redirect '/student-login' if @user.nil?


  @mentor_id = params['mentor_id']
  redirect '/dashboard' if @mentor_id.nil?

  erb :"/secure-area/student/report"
end

post '/dashboard/send-report' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 

  add_admin_event('The mentor with ID ' + params['mentor_id'] + ' was reported for "' + params['report_text'] + '"')
  redirect '/dashboard'
end

get '/dashboard/profile-page' do
  id_type = Login_Helper.get_id_and_type(session["session_token"])
  redirect '/' if id_type == nil or (id_type[1] != 'mentor' and id_type[1] != 'mentee') 

  @user = current_user
  if params['id'].nil? or params['id'] == "" then @user_showing = @user
  else @user_showing = Users.where(id: params['id']).first
  end
  if @user_showing.nil? then
    redirect '/dashboard'
  end
  
  erb :"/secure-area/shared/profile"
end

get '/logout' do
  session.clear
  erb :"secure-area/shared/logout"
end



