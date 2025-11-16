require_if_exist 'helpers'
include Notification_Helper
include UserHelper
include Login_Helper
include UserAdminHelper

get '/' do
  redirect '/dashboard' if session_token_exists(session['session_token'])
  erb :"main-homepage"
end

get '/student-login' do
  redirect '/dashboard' if session_token_exists(session['session_token'])
  erb :"student-login"
end

post '/student-login' do
  result = UserHelper.login_user(params, session)
  if result[:success]
    redirect '/dashboard'
  else
    erb :"student-login", locals: { error: result[:error] }
  end
end

get '/student-signup' do
  redirect '/dashboard' if session_token_exists(session['session_token'])
  erb :"student-signup"
end

post '/student-signup-form' do
  result = create_user(params)
  if result[:success]
    erb :"student-login"
  else
    erb :"student-signup", locals: { error: result[:error] }
  end
end


get '/admin-login' do
  redirect '/dashboard' if session_token_exists(session['session_token'])
  erb :"admin-login"
end

post '/admin-login' do
  result = UserHelper.login_admin(params, session)
  if result[:success]
    redirect '/dashboard'
  else
    erb :"admin-login", locals: { error: result[:error] }
  end
end


post '/admin-request-form' do
  email = params['email']
  extra_info = params['extra_info']

  add_admin_event("#{email} signed up as an admin.\nExtra info: #{extra_info}")

  redirect '/admin-login'
end


get '/terms' do
  erb :"terms"
end

get '/licences' do
  erb :"licences"
end