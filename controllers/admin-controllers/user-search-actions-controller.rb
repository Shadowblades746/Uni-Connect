get '/admin-private/user-search-page' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  search_query = params["searchterm"]
  if search_query == "" or search_query.nil?
    @users_list = Users.where(Sequel.ilike(:first_names, '%'))
  else
    search_query = h(search_query)
    search_query = "%" + search_query + "%"
    @users_list = Users.where(Sequel.ilike(:first_names, search_query)).or(Sequel.ilike(:last_name, search_query))
    .or(Sequel.ilike(:email, search_query))
  end
  erb :"secure-area/admin/admin-user-management"
end

post '/admin-private/user-search-page/modify-user/delete' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? || id_type[1] != 'admin'
    redirect '/'
  end

  user_to_delete = Users.where(id: params[:id].to_i).first

  if user_to_delete
    DB.transaction do
      if user_to_delete.user_status == 'mentor'
        mentee_requests = Requests.where(mentor_id: user_to_delete.id)
        mentee_requests.each do |req|
          send_notification_by_id(req.mentee_id, "Your mentor account (ID #{user_to_delete.id}) has been deleted by an admin.")
        end
        mentee_requests.delete
      elsif user_to_delete.user_status == 'mentee'
        mentee_request = Requests.where(mentee_id: user_to_delete.id).first
        if mentee_request&.mentor_id
          send_notification_by_id(mentee_request.mentor_id, "Your mentee account (ID #{user_to_delete.id}) has been deleted by an admin.")
        end
        Requests.where(mentee_id: user_to_delete.id).delete
      else
        @errors = 'Internal Server Error: User is not a mentor or mentee'
      end
      Notifications.where(id: user_to_delete.id).delete
      Users.where(id: user_to_delete.id).delete
    end
    add_admin_event("The user with ID #{params[:id]} was deleted.")
    redirect '/admin-private/user-search-page'
  else
    redirect '/admin-private/user-search-page'
  end
end

post '/admin-private/user-search-page/modify-user/badge' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  user_to_badge = Users.where(id: params[:id].to_i).first

  if user_to_badge && user_to_badge.user_status == 'mentor'
    if user_to_badge.badge.nil?
      user_to_badge.badge = 1
      add_admin_event("The mentor with ID #{params[:id]} was assigned a badge.")
      send_notification_by_id(user_to_badge.id, "You have been awarded a badge!")
    else
      user_to_badge.badge = nil
      add_admin_event("The mentor with ID #{params[:id]} had their badge removed.")
      send_notification_by_id(user_to_badge.id, "Your badge has been removed.")
    end
    user_to_badge.save_changes
  end

  redirect '/admin-private/user-search-page'
end

post '/admin-private/user-search-page/modify-user/flag' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  user_to_modify = Users.where(id: params[:id].to_i).first

  if user_to_modify
    if user_to_modify.flagged
      add_admin_event("The user with ID #{params[:id]} is already flagged.")
      redirect '/admin-private/user-search-page'
    else
      redirect "/admin-private/user-search-page/modify-user/flag/#{user_to_modify.id}"
    end
  end
end


post '/admin-private/user-search-page/modify-user/unflag' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  user_to_unflag = Users.where(id: params[:id].to_i).first

  if user_to_unflag&.flagged
    user_to_unflag.update(flagged: nil, flagged_reason: nil)
    add_admin_event("The user with ID #{params[:id]} was unflagged.")
    send_notification_by_id(user_to_unflag.id, "You have been unflagged.")
  else
    add_admin_event("The user with ID #{params[:id]} was not flagged or does not exist.")
  end

  redirect '/admin-private/flagged-users'
end

get '/admin-private/flagged-users' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  @user = current_admin
  @flagged_users = DB[:Users].where(flagged: '1').all
  erb :"/secure-area/admin/admin-flagged-users"
end

get '/admin-private/user-search-page/modify-user/flag/:id' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  @user = Users.where(id: params[:id].to_i).first
  erb :"/secure-area/admin/flag-user-form"
end

post '/admin-private/user-search-page/modify-user/flag/:id' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'admin' then
    redirect '/'
  end

  user = Users.where(id: params[:id].to_i).first

  user.update(flagged: true, flagged_reason: params[:reason])
  add_admin_event("The user with ID #{params[:id]} was flagged for: #{params[:reason]}.")
  send_notification_by_id(user.id, "You have been flagged for: #{params[:reason]}.")

  redirect '/admin-private/user-search-page'
end

post '/admin-private/user-search-page/modify-user/reassign' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  redirect '/' if id_type.nil? || id_type[1] != 'admin'

  admin = current_admin
  user_to_reassign = params[:id].to_i

  if admin.user_to_reassign.nil?
    mentee = Users.where(id: user_to_reassign, user_status: 'mentee').first
    request = Requests.where(mentee_id: user_to_reassign).first

    unless mentee && request && request.mentor_id
      add_admin_event("Reassignment failed: User with ID #{user_to_reassign} is not a valid mentee with a mentor.")
      return redirect '/admin-private/user-search-page'
    end

    admin.update(user_to_reassign: user_to_reassign)
    add_admin_event("Mentee with ID #{user_to_reassign} marked for reassignment.")
    return redirect '/admin-private/user-search-page'
  end

  last_user_id = admin.user_to_reassign
  request = Requests.where(mentee_id: last_user_id).first

  unless request
    add_admin_event("No request found for mentee with ID #{last_user_id}.")
    admin.update(user_to_reassign: nil)
    return redirect '/admin-private/user-search-page'
  end

  previous_mentor_id = request.mentor_id
  new_mentor = Users.where(id: user_to_reassign, user_status: 'mentor').first

  unless new_mentor
    add_admin_event("Reassignment failed: User with ID #{user_to_reassign} is not a valid mentor.")
    admin.update(user_to_reassign: nil)
    return redirect '/admin-private/user-search-page'
  end

  current_mentees_count = Requests.where(mentor_id: user_to_reassign).count
  if current_mentees_count >= new_mentor.mentee_capacity
    add_admin_event("Reassignment failed: Mentor with ID #{user_to_reassign} has reached their maximum mentee capacity.")
    admin.update(user_to_reassign: nil)
    return redirect '/admin-private/user-search-page'
  end

  request.update(mentor_id: user_to_reassign)
  send_notification_by_id(last_user_id, "Your mentor has been reassigned to Mentor ID #{user_to_reassign}.")
  send_notification_by_id(previous_mentor_id, "Mentee ID #{last_user_id} has been reassigned to another mentor.")
  send_notification_by_id(user_to_reassign, "You have been assigned a new mentee with ID #{last_user_id}.")
  add_admin_event("Request with ID #{request.id} updated: Mentor reassigned from ID #{previous_mentor_id} to ID #{user_to_reassign}.")

  admin.update(user_to_reassign: nil)
  redirect '/admin-private/user-search-page'
end