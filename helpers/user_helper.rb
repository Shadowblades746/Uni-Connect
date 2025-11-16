# frozen_string_literal: true
module UserHelper
  require_relative 'login_helper'
  include Login_Helper
  require_relative 'password_helper'
  include Password_Helper

  def create_user(params)
    existing_id = Users.where(id: params['u_card']).first
    existing_user_email = Users.where(email: params['email']).first

    if existing_id
      { success: false, error: 'User ID already exists. Please use a different User ID.' }
    elsif existing_user_email
      { success: false, error: 'Email already exists. Please use a different email.' }
    else
      user = Users.new
      email = params.fetch("email", "").to_s.strip
      if !str_email_address?(email) || email.empty?
        return { success: false, error: 'Error saving data: Please enter valid email address.'}
      end
      user.email = email

      if Password_Helper.secure_password?(params['password']) then
        user.password = Login_Helper.hash_password(params['password'])
      else
        return { success: false, error: Password_Helper.get_password_requirements() }
      end

      userid = params.fetch("u_card", "").to_s.strip
      if userid.empty? || !str_digits?(userid)
        return { success: false, error: 'Error saving data: Please enter a valid user ID'}
      end
      user.id = userid.to_i

      user.first_names = params.fetch("first_names", "").to_s.strip
      if user.first_names.empty?
        return { success: false, error: "Error saving data: Please enter your name(s)"}
      end

      user.last_name = params.fetch("last_name", "").to_s.strip
      if user.last_name.empty?
        return { success: false, error: "Error saving data: Please enter your surname"}
      end

      user.date_of_birth = params.fetch("date_of_birth", "").to_s.strip
      if user.date_of_birth.empty?
        return { success: false, error: "Error saving data: Please enter your date of birth"}
      end

      user.year_group = params['year_group']
      if user.year_group == '1st'
        user.user_status = 'mentee'
       else 
        user.user_status = 'mentor'
      end

      user.gender = params['gender']
      user.pronouns = params.fetch("pronouns", "").strip

      if user.user_status == "mentor"
        user.mentee_capacity = GlobalSettings.first.global_max_mentee_capacity
      end

      user.setup_complete = params['setup_complete'].to_i
      if params['profile_picture'] && params['profile_picture'][:tempfile]
        user.profile_picture = params['profile_picture'][:tempfile].read
      end

      if user.save
        Notification_Helper.send_notification_by_id(user.id, "Welcome to UniConnect #{user.first_names}!")
        { success: true }
      else
        { success: false, error: 'There was an error saving your data. Please try again.' }
      end
    end
  end

  def login_user(params, session)
    user = Users.where(email: params['email']).first
    if user && Login_Helper.valid_password?(params['password'], user.password)
      session_token = nil
      loop do
        session_token = Login_Helper.create_session_token
        break unless Login_Helper.session_token_exists(session_token)
      end

      user.update(session_token: session_token)
      session['session_token'] = session_token
      { success: true }
    else
      { success: false, error: 'Invalid email or password. Please try again.' }
    end
  end

  def create_admin(params)
    existing_admin_email = Admins.where(email: params['email']).first

    if existing_admin_email
      { success: false, error: 'Email already exists. Please use a different email.' }
    else
      admin = Admins.new
      admin.email = params['email']
      admin.password = Login_Helper.hash_password(params['password'])
      admin.first_names = params['first_names']
      admin.last_name = params['last_name']

      if admin.save
        { success: true }
      else
        { success: false, error: 'There was an error saving your data. Please try again.' }
      end
    end
  end

  def login_admin(params, session)
    admin = Admins.where(email: params['email']).first
    if admin && Login_Helper.valid_password?(params['password'], admin.password)
      session_token = nil
      loop do
        session_token = Login_Helper.create_session_token
        break unless Login_Helper.session_token_exists(session_token)
      end

      admin.update(session_token: session_token)
      session['session_token'] = session_token
      { success: true }
    else
      { success: false, error: 'Invalid email or password. Please try again.' }
    end
  end
end
