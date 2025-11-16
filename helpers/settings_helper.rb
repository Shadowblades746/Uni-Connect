module Settings_Helper

  def edit_profile(params)
    user = Users.where(session_token: session["session_token"]).first

    bio = params.fetch("edit_bio", "").to_s.strip
    if bio.nil? || bio.empty?
      return { success: false, error: "Error saving data: Bio cannot be empty, please enter a short introduction of yourself." }
    end
    user.bio = bio

    if params['profile_picture'] && params['profile_picture'][:tempfile]
      user.profile_picture = params['profile_picture'][:tempfile].read
    end

    if (user.user_status == "mentor") then
      user.mentor_availability = params.fetch("edit_availability", "").to_s.strip 
      global_max = GlobalSettings.first.global_max_mentee_capacity
      input_capacity = params['mentee_capacity'].to_i
      if input_capacity > global_max || input_capacity < 1
        return {success: false, error: 'Invalid mentee capacity, please enter a number between 1 and #{global_max}'}
      end
      user.mentee_capacity = input_capacity
    end

    if user.save_changes
      Notification_Helper.send_notification_by_id(user.id, "Profile changes updated!")
      { success: true }
    else
      { success: false, error: 'There was an error saving your data. Please try again.' }
    end

  end

  def edit_personal_details(params)
    user = Users.where(session_token: session['session_token']).first

    name = params.fetch("edit_first_name", "").to_s.strip
    if name.empty?
      return { success: false, error: 'Error saving data: Name field cannot be empty, please enter your first name(s)'}
    end
    user.first_names = name
    user.gender = params['edit_gender']
    user.pronouns = params.fetch("edit_pronouns", "").to_s.strip

    if user.save_changes
      { success: true}
    else
      { success: false, error: 'There was an error saving your data. Please try again'}
    end
  end

  def finish_account_setup(params)
    user = Users.where(session_token: session["session_token"]).first

    if params['profile_picture'] && params['profile_picture'][:tempfile]
      puts "pfp"
      user.profile_picture = params['profile_picture'][:tempfile].read
    end

    bio = params.fetch("edit_bio", "").to_s.strip
    if bio.empty?
      return { success: false, error: 'Error saving data: Please enter a short description of yourself'}
    end
    user.bio = bio

    if (user.user_status == "mentor") then
      user.mentor_availability = params.fetch("edit_availability", "").to_s.strip
      global_max = GlobalSettings.first.global_max_mentee_capacity
      entered_capacity = params.fetch("mentee_capacity", "").to_s.strip
      if !entered_capacity.empty? && !str_digits?(params.fetch("mentee_capacity"))
        return {success: false, error: 'Invalid entry, please enter a number between 1 and #{global_max}'}
      end
      if entered_capacity.to_i > global_max || entered_capacity.to_i < 1
        return {success: false, error: 'Invalid mentee capacity, please enter a number between 1 and #{global_max}'}
      end
      user.mentee_capacity = entered_capacity.to_i
    end

    if !user.bio.nil?
      user.setup_complete = 1
    end
    
    if user.save_changes
      Notification_Helper.send_notification_by_id(user.id, "Profile changes updated!")
      { success: true }
    else
      { success: false, error: 'There was an error saving your data. Please try again.' }
    end
  end
end
