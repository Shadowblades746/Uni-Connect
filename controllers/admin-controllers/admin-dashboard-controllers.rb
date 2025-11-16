# frozen_string_literal: true

post '/dashboard/update_global_mentee_max' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? || id_type[1] != 'admin'
    redirect '/'
  end

  settings = GlobalSettings.first

  if params[:global_mentee_max].to_i > 0
    settings.update(global_max_mentee_capacity: params[:global_mentee_max].to_i)
    add_admin_event("Global mentee max updated to #{params[:global_mentee_max]}.")
  end
  redirect '/dashboard'
end

get '/dashboard/admin-activity' do
  user = current_admin
  redirect '/admin-login' if user.nil?

  @user = user
  erb :"/secure-area/admin/admin-activity"
end

post '/dashboard/admin-activity' do
  if params['all_viewed'] == '1'
    mark_all_admin_event_viewed
  else
    mark_admin_event_viewed(params['id'])
  end

  redirect '/dashboard/admin-activity'
end

get '/admin-change-password' do
  user = current_admin
  redirect '/admin-login' if user.nil?

  erb :"/secure-area/admin/admin-change-password"
end

post '/admin-change-password' do
  if session['session_token'].nil? || Admins.where(session_token: session['session_token']).nil?
    redirect '/admin-login'
  end

  user = Admins.where(session_token: session['session_token']).first
  user.password = Login_Helper.hash_password(params['password'])
  user.changed_password = 1
  user.save_changes
  redirect '/dashboard'
end

post '/dashboard/admin-signup-form' do
  result = create_admin(params)
  if result[:success]
    redirect '/admin-login'
  else
    erb :"/secure-area/admin/admin-dashboard", locals: { error: result[:error] || 'An unknown error occurred.' }
  end
end


get '/admin-signup' do
  redirect '/dashboard' if session_token_exists(session['session_token'])
  erb :"admin-signup"
end