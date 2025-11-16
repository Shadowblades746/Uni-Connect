# models/Users.rb
require 'sequel'

class Users < Sequel::Model
  def full_name
    first_names + " " + last_name
  end

  def getMatches
    matchesSum = 0
    Requests.each do |req|
      if req.mentor_id == id or req.mentee_id = id
        matchesSum += 1
      end
    end
    return matchesSum
  end

end

