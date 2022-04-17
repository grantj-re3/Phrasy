#
# Copyright (C) 2022 Grant Jackson
# Licensed under GPLv3. http://www.gnu.org/licenses/gpl-3.0.html
#
##############################################################################
### Guess-Input Text-User-Interface
##############################################################################
class GuessInputTextUI

  ############################################################################
  def initialize(is_allow_show_phrase=false)
    @is_allow_show_phrase = is_allow_show_phrase
  end

  ############################################################################
  def get_input_attrs(prompt_first, prompt_more=nil, previous_guesses=[])
    prompt_more ||= prompt_first
    is_first = true

    while true
      if is_first
        printf prompt_first
        is_first = false

      else
        printf prompt_more
      end

      str = STDIN.readline.strip.squeeze(" ").upcase
      case str
      when ':Q'
        return {:type => :quit}

      when ':S'
        return {:type => :show_phrase} if @is_allow_show_phrase

      else
        next if previous_guesses.include?(str)  # Don't permit repeated guesses
        return {:type => :guess, :data => str} if str.match(/^[a-z ]+$/i)
      end
    end
  end

end

