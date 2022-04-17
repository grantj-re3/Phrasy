#
# Copyright (C) 2022 Grant Jackson
# Licensed under GPLv3. http://www.gnu.org/licenses/gpl-3.0.html
#
##############################################################################
### Configuration
##############################################################################
# Extend the Config class (from separate file, ConfigFilepath)
class Config
  ClueStatusLengths = [:long, :short]
  ClueStatusFormats = [:clue_status_pairs, :one_status, :no_status]

  attr_reader :arg, :key_order, :phrasefiles, :help

  ############################################################################
  def initialize
    @key_order = [
      :max_guesses,
      :max_phrase_chars,
      :delim,
      :section_delim,
      :prompt,

      :clue_length,
      :status_length,
      :clue_status_format,
      :is_pause_at_end_game,

      :is_allow_show_phrase,
      :is_show_config,
      :column_position_count,
    ]
    user_config if Config.method_defined?(:user_config)

    clean_user_args
    clean_user_help
    validate_user_args
    validate_user_phrasefiles
  end

  ############################################################################
  def clean_user_args
    # Add defaults and override some invalid configs
    @arg ||= {}

    @arg[:max_guesses] ||= 20
    @arg[:max_guesses] = 99 if @arg[:max_guesses] > 99  # Text UI assumes 1 or 2 digits
    @arg[:max_guesses] = 1  if @arg[:max_guesses] < 1   # Script assumes 1 or more

    # Maximum number of characters permitted in the phrase
    @arg[:max_phrase_chars] ||= 80

    # Delimiter strings: Typically 1-3 characters
    @arg[:delim]                  ||= "|"
    @arg[:section_delim]          ||= "|"

    # String to prompt the user to input the guess
    @arg[:prompt]                 ||= "Letters? "

    # The header text which appears above the clue column
    @arg[:clue_header_text]       ||= "Phrase"

    # :long or :short
    @arg[:clue_length]            ||= :short
    @arg[:status_length]          ||= :short

    # :one_status or :no_status
    @arg[:clue_status_format]     ||= :one_status

    # If set to true, this option pauses at the end of the game.
    @arg[:is_pause_at_end_game]   ||= false

    # DEBUG: Allow user to cheat by showing the phrase! Useful during debugging.
    @arg[:is_allow_show_phrase]   ||= false

    # DEBUG: Show the configuration parameters
    @arg[:is_show_config]         ||= false

    # DEBUG: Print lines which show column positions.
    @arg[:column_position_count]  ||= 0

  end

  ############################################################################
  def clean_user_help
    # Add defaults and override some invalid configs
    @help ||= {}

    @help[:text] ||= <<-EOF.gsub(/^ {6}/, '')

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
      - The "Untried letters" column only shows *individual* letters (not
        sequences) which have not yet been attempted during the game.
      - Better results are indicated by less guesses/turns.
      - ':q' to quit (without the quotes).

    EOF
  end

  ############################################################################
  def validate_user_args
    error = false
    unless ClueStatusLengths.include?(@arg[:clue_length])
      error = true
      printf "CONFIGURATION ERROR:\n  %s is %s\n  Must be one of %s\n" %
        ["@arg[:clue_length]", @arg[:clue_length].inspect, ClueStatusLengths.inspect]
    end

    unless ClueStatusLengths.include?(@arg[:status_length])
      error = true
      printf "CONFIGURATION ERROR:\n  %s is %s\n  Must be one of %s\n" %
        ["@arg[:status_length]", @arg[:status_length].inspect, ClueStatusLengths.inspect]
    end

    unless ClueStatusFormats.include?(@arg[:clue_status_format])
      error = true
      printf "CONFIGURATION ERROR:\n  %s is %s\n  Must be one of %s\n" %
        ["@arg[:clue_status_format]", @arg[:clue_status_format].inspect, ClueStatusFormats.inspect]
    end

    if error
      puts to_s
      puts "QUITTING!"
      exit 1
    end
  end

  ############################################################################
  def validate_user_phrasefiles
    error = false
    unless @phrasefiles
      error = true
      puts <<-EOF.gsub(/^ {8}/, '')
        CONFIGURATION ERROR:
          @phrasefiles is undefined or nil in the user config file.
          It should be a Hash.

      EOF
    end

    unless @phrasefiles && @phrasefiles[nil]
      error = true
      puts <<-EOF.gsub(/^ {8}/, '')
        CONFIGURATION ERROR:
          @phrasefiles[nil] is undefined or nil in the user config file.
          It should be a string, naming a file located in the folder
          #{PhraseFilesDir}
          containing the default phrase-list.

      EOF
    end

    if error
      puts to_s
      puts "QUITTING!"
      exit 2
    end
  end

  ############################################################################
  def to_s
    a = [ "\nConfiguration parameters (arg):\n" ]
    @key_order.each{|k| a << "  %-24s => %-24s\n" % [k.inspect, @arg[k].inspect]}

    a << [ "\nConfiguration parameters (phrasefiles):\n" ]
    fname_msg = @phrasefiles && @phrasefiles[nil] ?
      @phrasefiles[nil].inspect :
      "Error: No file configured"
    s = "Default phrase list file (key=nil)"
    a << "  %-33s => %s\n" % [s, fname_msg]

    if @phrasefiles
      @phrasefiles.keys.sort{|a,b| a.to_s.to_i <=> b.to_s.to_i}.each{|k|
        next if k.nil?
        s = "%d-letter phrase list file (key=%d)" % [k, k]
        a << "  %-33s => %s\n" % [s, @phrasefiles[k].inspect]
      }
    end
    a << "\n"
    a.join("")
  end

end

