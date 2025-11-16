require_if_exist "helpers"
include Login_Helper

get "/dashboard/delete-account" do
  if session_token_exists(session["session_token"]) then
    if Login_Helper.get_id_and_type(session["session_token"])[1] == 'admin' then
      redirect '/'
    end

    @user = Users.where(session_token: session["session_token"]).first
    @errors = session["error_msg"]
    session["error_msg"] = "" # Reset error message
    erb :"secure-area/student/account-deletion/delete-account"
  else
    redirect "/"
  end
end

post "/dashboard/delete-account/confirm-delete-account" do 
  if session_token_exists(session["session_token"]) then
    if Login_Helper.get_id_and_type(session["session_token"])[1] == 'admin' then
      redirect '/'
    end
    
    user_to_delete = Users.where(session_token: session["session_token"]).first
    @user = user_to_delete
  else
    redirect "/"
  end
  
  if not params["password"].eql?(params["repeat_password"]) then
    session["error_msg"] = "The entered passwords do not match"
    redirect "/dashboard/delete-account"
  end

  if not Login_Helper.valid_password?(params["password"], user_to_delete.password) then
    session["error_msg"] = "The entered passwords are incorrect"
    redirect "/dashboard/delete-account"
  end

  if user_to_delete.user_status == "mentor" then
    Requests.where(mentor_id: user_to_delete.id).delete
  elsif user_to_delete.user_status == "mentee" then
    Requests.where(mentee_id: user_to_delete.id).delete
  else
    @errors = "Internal Server Error: User is not a mentor or mentee"
  end

  Notifications.where(id: user_to_delete.id).delete
  Users.where(id: user_to_delete.id).delete

  UserWithdrawalRequests.where(primary_user_id: user_to_delete.id).delete
  UserWithdrawalRequests.where(secondary_user_id: user_to_delete.id).delete

  Requests.where(mentee_id: user_to_delete.id).delete
  Requests.where(mentor_id: user_to_delete.id).delete

  session.clear
  redirect "/account-deleted"
end

get "/account-deleted" do
  erb :"secure-area/student/account-deletion/successfull-deletion"
end