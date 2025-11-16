require_if_exist 'helpers'
include Notification_Helper
include UserAdminHelper

get '/dashboard/notifications' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'mentor' and id_type[1] != 'mentee' then
    redirect '/'
  end
  @user = Users.where(session_token: session["session_token"]).first
  erb :"/secure-area/shared/notifications"
end

post '/dashboard/notifications' do
  id_type = Login_Helper.get_id_and_type(session['session_token'])
  if id_type.nil? then
    redirect '/'
  elsif id_type[1] != 'mentor' and id_type[1] != 'mentee' then
    redirect '/'
  end
  @user = Users.where(session_token: session["session_token"]).first

  if params['all_read'] == '1'
    Notification_Helper.mark_all_notifications_as_read(@user.id)
  else
    Notification_Helper.mark_notification_as_read(params['id'])
  end

  redirect "/dashboard/notifications"
end
