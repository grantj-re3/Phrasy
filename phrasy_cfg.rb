#
# Copyright (C) 2022 Grant Jackson
# Licensed under GPLv3. http://www.gnu.org/licenses/gpl-3.0.html
#
##############################################################################
### The user-config file
##############################################################################
class Config

  def user_config
    ##########################################################################
    # @phrasefiles allows you to specify a phraselist file
    # (where the key must be nil)
    #
    # Format example:
    #   nil => "phraselist.txt",
    @phrasefiles = {
      # The phraselist file (mandatory)
      nil => "ProverbialPhrases1l.txt",
    }

    ##########################################################################
    @arg = {
      # Maximum number of guesses permitted
      :max_guesses            => 20,

      # Maximum number of characters permitted in the phrase
      :max_phrase_chars       => 80,

      # Delimiter strings: Typically 1-3 characters
      :delim                  => "|",
      :section_delim          => "|",

      # String to prompt the user to input the guess
      :prompt                 => "Letters? ",

      # The header text which appears above the clue column
      :clue_header_text       => "Phrase",

      # :short = show the clue/status character only
      # :long  = same as :short but add a space to the right of each clue/status character
      #
      # - Use :long for better formatting (more white space) when you have
      #   plenty of characters on your line available for clues/status.
      # - Use :short when you have less characters on your line
      :clue_length            => :short,
      :status_length          => :short,

      # Examples of clue-status formats on the display:
      # - :one_status        = word-phrase|word-lengths|status
      # - :no_status         = word-phrase|word-lengths
      :clue_status_format     => :one_status,

      # If invoked via a file manager, the xterm usually vanishes when the
      # script exits. If set to true, this option pauses at the end of the
      # game, allowing the score, etc. to remain visible.
      :is_pause_at_end_game   => false,

      # DEBUG: Allow user to cheat by showing the phrase! Useful during debugging.
      :is_allow_show_phrase   => true,

      # DEBUG: Show the configuration parameters
      :is_show_config         => true,

      # DEBUG: Print lines which show column positions. This value specifies how
      # many column positions to show (usually 80 or more). Do not print debug
      # lines if value is 0. This debug feature is useful when configuring the
      # Text User Interface to see how many characters will fit on your xterm
      # (or console).
      ##:column_position_count  => 168,
      ##:column_position_count  => 79,
      :column_position_count  => 0,
    }


    ##########################################################################
    @help = {}

    @help[:show_cmd] = @arg[:is_allow_show_phrase] ?
      "- ':s' to show the target phrase (without the quotes)"  :  ""

    @help[:text] = <<-EOF.gsub(/^ {6}/, '')

      =====================================================
      P H R A S Y - P H R A S E   G U E S S I N G   G A M E
      =====================================================
      Config file at #{ConfigFilepath}


      The game of Phrasy is a phrase-guessing game which is almost
      identical to the game of hangman. In each game you are trying
      to guess a phrase. E.g. EVERY CLOUD HAS A SILVER LINING.

      - The game starts by displaying the phrase with a dot where each
        letter would appear.
      - For each guess, enter a single letter or a sequence of letters.
      - You have #{@arg[:max_guesses]} guesses.
      - If an exact match is present in the phrase, the matching letters or
        sequence will be displayed.
        * For example if the secret phrase was "EVERY CLOUD HAS A SILVER
          LINING" and you entered "v", a "V" whould be shown in positions
          2 and 24.
        * If you entered "ning", then "NING" would be shown at the end of
          the phrase.
        * If you entered "ver lining", then "VER LINING" would be shown
          at the end of the phrase. 
        * If you entered "la" then no extra information would be displayed
          because that *sequence* is not present (even though "L" and "A"
          are present).
      - Better results are indicated by less guesses/turns.
      - ':q' to quit (without the quotes).
      #{@help[:show_cmd]}

    EOF

  end

end

