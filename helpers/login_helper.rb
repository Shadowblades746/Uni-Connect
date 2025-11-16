# lib/password_helper.rb
require 'openssl'
require 'base64'

module Login_Helper

  def secure_password?(password)
    # This function should check whether the password is missing anything important
    # for security, and return a true/false value.
    true
  end

  def hash_password(password)
    salt = OpenSSL::Random.random_bytes(16)
    iter = 20_000
    key_len = 32
    digest = OpenSSL::Digest.new('SHA256')
    key = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iter, key_len, digest)
    Base64.encode64(salt + key)
  end

  def valid_password?(entered_password, salt_key_combo)
    stored_password = Base64.decode64(salt_key_combo)
    salt = stored_password[0, 16]
    iter = 20_000
    key_len = 32
    digest = OpenSSL::Digest.new('SHA256')
    key = OpenSSL::PKCS5.pbkdf2_hmac(entered_password, salt, iter, key_len, digest)
    stored_key = stored_password[16..]
    key == stored_key
  end

  # Creates a random token that is associated with a user
  # for the current browsing session.
  # This should ALWAYS be used to identify a user, to prevent
  # collisions between id's and admin_id's, and to prevent
  # an attack where someone modifies there session to get into another
  # users profile.
  def create_session_token()
    rand = OpenSSL::Random.random_bytes(32)
    Base64.encode64(rand).strip
  end

  def session_token_exists(input_session_token)
    return false if input_session_token.nil?

    user = Users.where(session_token: input_session_token).first
    return true unless user.nil?

    admin = Admins.where(session_token: input_session_token).first
    true unless admin.nil?
  end

  def get_id_and_type(input_session_token)
    if input_session_token.nil? then 
      return nil
    end

    user = Users.where(session_token: input_session_token).first

    if user.nil? then
      admin = Admins.where(session_token: input_session_token).first
      if admin.nil? then
        # Session token no-longer valid since doesn't exist
        # in db
        return nil  
      else
        return [admin.id, "admin"]
      end
    else
      return [user.id, user.user_status]
    end
  end
end

