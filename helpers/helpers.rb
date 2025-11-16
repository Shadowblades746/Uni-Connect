require_relative "validation"
# Add more "require" statements for your helpers here
require_relative "notification_helper"
require_relative "user_helper"
require_relative "settings_helper"
require_relative "user_admin_helper"

# Register helpers with Sinatra
helpers do
  # This is so that we get to use the "h" method in views
  include ERB::Util

  # This is so that we include useful validation methods
  include Validation
  include Notification_Helper
  include UserHelper
  include Settings_Helper
  include UserAdminHelper

  # Add your own helper modules to this file
  require_if_exist "helpers/local_helpers"
end
