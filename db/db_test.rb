# Copy of db.rb where the test db is always loaded.
# Added as the check for APP_ENV when running RSpec tests does not seem to work
# correctly.

require "logger"
require "sequel"

# Start to build the path to the database/log file
path = "#{__dir__}/db"
path += "_test"

# Instantiate a logger for the database
logger_file_path = "#{path}.log"
logger = Logger.new(logger_file_path)

# Initialise the database
db_file_path = "#{path}.sqlite3"
if File.exist?(db_file_path)
  logger.info("Database file found and loaded ('#{db_file_path}')")
  DB = Sequel.sqlite(db_file_path, logger: logger)
else
  logger.warn("Database file not found (looking for '#{db_file_path}')")
end
