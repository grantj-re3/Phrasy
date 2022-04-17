#
# Copyright (C) 2022 Grant Jackson
# Licensed under GPLv3. http://www.gnu.org/licenses/gpl-3.0.html
#
##############################################################################
require "config"

##############################################################################
### Phrasy game
##############################################################################
class Game
  GetPhraseMaxCount = 10
  RANGE_AZ = 'A'..'Z'

  @@phrases = nil                                   # Large array of phrases
  @@get_unique_phrase_max_count = 0

  attr_reader :num_chars, :max_guesses, :num_guesses, :guesses_done,
    :guess_list, :status, :chars_tried, :phrase, :guess, :clues

  ############################################################################
  def initialize(opts={})
    @cfg = Config.new

    @max_guesses     = opts.fetch(:max_guesses,     @cfg.arg[:max_guesses])
    @exclude_phrases = opts.fetch(:exclude_phrases, [])

    @num_guesses = 0
    @chars_tried = {}                 # No chars tried initially
    get_target_phrase                 # Assign @phrase

    @guess = nil                      # The user's current guess of @phrase
    @guess_list = []                  # List of previous guesses
    @clues = @phrase.split("").map{|c| c.match(/[A-Z]/) ? nil : c}
  end

  ############################################################################
  def self.phrases
    @@phrases
  end

  ############################################################################
  def get_phraselist_path
    fname = @cfg.phrasefiles[nil]
    "#{PhraseFilesDir}/#{fname}"
  end

  ############################################################################
  def load_all_phases
    return if @@phrases    
    @@phrases = []
    line_count = 0

    phraselist_path = get_phraselist_path
    begin
      File.foreach(phraselist_path){|line|
        line_count += 1
        line_redone = line.strip.squeeze(" ").upcase
        next if line_redone.length > @cfg.arg[:max_phrase_chars]
        @@phrases << line_redone
      }

    rescue => ex
      puts "ERROR: #{ex}"
      exit 11
    end

    @@phrases.uniq!                     # Exclude repeated phrases
    puts "Loaded #{@@phrases.length} phrases (from phrase list of #{line_count})"
    puts "The phrase list is located at #{phraselist_path}"
    if @@phrases.length < 1
      puts "ERROR: Insufficient phrases to play the game"
      exit 12
    end
  end

  ############################################################################
  def get_target_phrase
    load_all_phases
    GetPhraseMaxCount.times{|i|
      @@get_unique_phrase_max_count = i+1 if i >= @@get_unique_phrase_max_count
      index = rand(0...@@phrases.length)
      @phrase = @@phrases[index]
      return unless @exclude_phrases.include?(@phrase)
    }
    STDERR.puts <<-EOF.gsub(/^[ \t]*/, "")

      ERROR: After #{GetPhraseMaxCount} attempts, we could not find a random phrase from
      our phrase list which is not in the excluded-phrase-list! Quitting.
    EOF
    exit 13
  end

  ############################################################################
  def self.get_unique_phrase_max_count
    @@get_unique_phrase_max_count
  end

  ############################################################################
  def new_guess(guess)
    @guess = guess              # Assume guess string is already sanitized
    @guess_list << guess
    @num_guesses += 1
  end

  ############################################################################
  def calc_clues_status
    pos = @phrase.index(@guess)
    while pos
      @guess.split("").each_with_index{|ch,i| @clues[pos + i] = ch}
      pos = @phrase.index(@guess, pos+1)
    end

    # Feedback status re all chars we've tried in all guesses in this game
    # Check for guessed char not in the target phrase
    @chars_tried[@guess] = true if @guess.length == 1
  end

  ############################################################################
  def correct
    @clues.join("") == @phrase
  end

  ############################################################################
  def score_summary_s
    num_words = @phrase.split(" ").length
    a = @phrase.split("") - [" "]     # The chars with spaces removed
    num_chars = a.length
    num_unique_chars = a.uniq.length

    if correct
      result = "SUCCESS"
      mult6 = 175.0
      score = @num_guesses == 0 ? 0 : (mult6 * num_unique_chars / @num_guesses ** 1.5 + 0.5).to_i
      #hit_rate = @num_guesses == 0 ? 0 : (100.0 * num_unique_chars / @num_guesses + 0.5).to_i
    else
      result = "FAIL"
      score = 0
    end

    "%s | %d turn(s) | %d words | %d letters | %d unique | %d%% score" % [
      result, @num_guesses, num_words, num_chars, num_unique_chars, score
    ]
  end

end

