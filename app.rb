# Gems
require 'require_all'
require 'sinatra'
require 'openssl'
require 'base64'
require 'sequel'

# Database file path
db_file = 'db/db.sqlite3'

# Connect to the database
DB = Sequel.connect("sqlite://#{db_file}")

# Create tables if the database file does not exist
unless File.exist?(db_file) && DB.tables.size > 1
  DB.create_table :Users do
    primary_key :id
    String :user_status
    String :badge
    Integer :flagged
    String :flagged_reason
    String :bio
    String :email
    String :first_names
    String :last_name
    String :gender
    String :pronouns
    String :year_group
    String :date_of_birth
    File :profile_picture
    String :password
    String :session_token
  end

  DB.create_table :Admins do
    primary_key :id
    String :email
    String :first_names
    String :last_name
    String :password
    String :session_token
  end

  DB.create_table :Notifications do
    primary_key :notification_id
    Integer :id
    String :text
    String :date
    String :time
    Integer :notification_read
    foreign_key [:id], :Users
  end

  DB.create_table :Requests do
    primary_key :request_id
    Integer :mentor_id
    Integer :mentee_id
    String :application_text
    String :date
    String :time
    Integer :acceptance_status
  end

  DB.create_table :UserSettings do
    primary_key :settings_id
    Integer :user_id
    String :user_status
    String :bio
    String :email
    String :first_names
    String :last_name
    String :gender
    String :year_group
    String :date_of_birth
    File :profile_picture
    String :password
    foreign_key [:user_id], :Users
  end

  DB.create_table :GlobalSettings do
    primary_key :global_settings_id
    Integer :global_max_mentee_capacity
  end

  DB.create_table :AdminActivity do
    primary_key :event_id
    String :event_text
    String :event_date
    String :event_time
    Integer :event_viewed
  end
end


# Check if the Users table is empty
if DB[:Users].count.zero? && File.exist?('db/data.sql')
  # Load and execute the SQL file
  DB.run(File.read('db/data.sql'))
end

# Bootstrapping method to only require files/whole directories if they exist
def require_if_exist(file_path)
  abs_file_path = File.expand_path(file_path, __dir__)

  if File.file?("#{abs_file_path}.rb")
    require abs_file_path
  elsif File.directory?(abs_file_path)
    require_all abs_file_path
  end
end

# Require application files and directories
require_if_exist 'controllers'
require_if_exist 'helpers/helpers'
require_if_exist 'db/db'
require_if_exist 'models'



# Sessions
enable :sessions