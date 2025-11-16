module UserAdminHelper
  def current_user
    Users.where(session_token: session['session_token']).first
  end

  def current_admin
    Admins.where(session_token: session['session_token']).first
  end

  def redirect_to_login
    if current_user
      redirect '/student-login'
    elsif current_admin
      redirect '/admin-login'
    end
  end

  # helpers/login_helper.rb
  def redirect_to_dashboard
    if current_user
      redirect '/dashboard'
    elsif current_admin
      redirect '/admin-dashboard'
    end
  end
end
