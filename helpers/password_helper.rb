module Password_Helper

  def get_password_requirements()
    return "The password you entered is not secure. Your password must be" +
    " at least 8 characters, contain a number, and at least one of the following special" +
    " characters: ! £ $ % & - _ @ ?"
  end
  
  def secure_password? password
    if password.length < 8 
      return false
    end

    if string_contains_disallowed_symbol?(password) then
      return false
    end

    if not string_contains_number?(password) then
      return false
    end

    if not string_contains_symbol?(password) then
      return false
    end

    # Password meets requirements
    return true
  end

  def string_contains_number?(input_string)
    numbers_regex = /[1234567890]/
    return numbers_regex.match?(input_string)
  end

  def string_contains_symbol?(input_string)
    # Allows the special characters ->  ! £ $ % & - _ @ ?
    symbols_regex = /[\!\£\$\%\&\-\_\@\?]/
    return symbols_regex.match?(input_string)
  end

  def string_contains_disallowed_symbol?(input_string)
    # Disallows the special characters ->  < > / \ | : ; ' " ^ ( ) * + = ` ¬ [ ]
    disallowed_symbols_regex = /[\<\>\/\\\|\:\;\'\"\^\(\)\*\+\=\`\¬\[\]]/
    return disallowed_symbols_regex.match?(input_string)
  end
end
