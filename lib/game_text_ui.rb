#
# Copyright (C) 2022 Grant Jackson
# Licensed under GPLv3. http://www.gnu.org/licenses/gpl-3.0.html
#
##############################################################################
require "game"
require "guess_input_text_ui"

##############################################################################
### Game Text-User-Interface
##############################################################################
class GameTextUI
  RANGE_AZ = Game::RANGE_AZ

  attr_reader :game, :cfg

  ############################################################################
  def initialize(game)
    @cfg = Config.new
    @game = game
    @lengths = @game.phrase.split(" ").map{|s| s.length}.join(",")

    setup_layout
    setup_prompts
  end

  ############################################################################
  def delim
    @cfg.arg[:delim]
  end

  ############################################################################
  def section_delim
    @cfg.arg[:section_delim]
  end

  ############################################################################
  def pad_delim
    " " * @cfg.arg[:delim].length
  end

  ############################################################################
  def pad_section_delim
    " " * @cfg.arg[:section_delim].length
  end

  ############################################################################
  def setup_layout
    @pad_s_clue      = @cfg.arg[:clue_length] == :long ? " " : ""
    @pad_factor_clue = @cfg.arg[:clue_length] == :long ? 2 : 1

    @pad_s_status      = @cfg.arg[:status_length] == :long ? " " : ""
    @pad_factor_status = @cfg.arg[:status_length] == :long ? 2 : 1
  end

  ############################################################################
  def setup_prompts
    pad_s_lengths = " " * @lengths.length
    delim_plus_status = @cfg.arg[:clue_status_format] == :one_status ?
      "%s%s" % [ pad_delim, status_string(:padding) ] : ""
    @prompt_prepadding = "%s%s%s%s" % [
      clues_string(:padding), pad_section_delim, pad_s_lengths,
      delim_plus_status,
    ]

    hdr = "Size"[0...@lengths.length]
    hdr_s_lengths = pad_s_lengths.gsub(/^ {#{hdr.length}}/, hdr)
    hdr_delim_plus_status = @cfg.arg[:clue_status_format] == :one_status ?
      "%s%s" % [ delim, status_string(:heading) ] : ""
    @prompt_preheading = "%s%s%s%s" % [
      clues_string(:heading), section_delim, hdr_s_lengths,
      hdr_delim_plus_status,
    ]
  end

  ############################################################################
  def prompt
    "%s%2d%s%s" % [section_delim, @game.num_guesses + 1, section_delim, @cfg.arg[:prompt]]
  end

  ############################################################################
  def prompt_more
    @prompt_prepadding + prompt
  end

  ############################################################################
  def show_preprompt_padding
    printf @prompt_prepadding
  end

  ############################################################################
  def show_preprompt_heading
    printf @prompt_preheading
  end

  ############################################################################
  def clues_string(type=nil)
    # Valid types = :normal, :heading or :padding. Nil implies :normal.

    if type == :padding || type == :heading
      s = " " * @pad_factor_clue * @game.phrase.length
      if type == :padding
        return s

      else    # type == :heading
        hdr = @cfg.arg[:clue_header_text][0...s.length]
        return s.gsub(/^ {#{hdr.length}}/,  hdr)
      end
    end
    @game.clues.map{|ch| (ch ? ch : ".") + @pad_s_clue}.join("")
  end

  ############################################################################
  def show_preprompt_clue_status
    printf "%s%s%s" % [ clues_string, section_delim, @lengths ]
    if @cfg.arg[:clue_status_format] == :one_status
      printf "%s%s" % [ delim, status_string ]
    end
  end

  ############################################################################
  def status_string(type=nil)
    # Valid types = :normal, :heading, :padding. Nil implies :normal.

    if type == :padding || type == :heading
      s = " " * @pad_factor_status * RANGE_AZ.to_a.length
      if type == :heading
        return s.gsub(/^ {15}/, "Untried letters")
      else
        return s
      end
    end

    a = []
    RANGE_AZ.each{|ch| a << (@game.chars_tried[ch] ? "." : ch) + @pad_s_status}
    a.join("")
  end

  ############################################################################
  def show_score(pre_string="")
    puts "%sYou had %s guesses.\nScore summary: %s" % [pre_string, @game.num_guesses, @game.score_summary_s]
  end

  ############################################################################
  def show_phrases(opts={})
    opts = {
      :past_tense => true,
      :pre_string => ""
    }.merge(opts)
    verb = opts[:past_tense] ? "was" : "is"
    puts "%sThe phrase %s: %s." % [opts[:pre_string], verb, @game.phrase]
  end

  ############################################################################
  def process_game_end
    if @game.correct
      show_score("\n\nCongratulations!!!\n")
      return :break

    elsif @game.num_guesses >= @game.max_guesses
      show_phrases(:pre_string => "\n\nBad luck!  ")
      show_score
      return :break
    end
    nil
  end

  ############################################################################
  def debug_show_column_position
    return if @cfg.arg[:column_position_count] <= 0
    a_line1 = (1..@cfg.arg[:column_position_count]).inject([]){|a,i| i%10 == 0 ? a << ((i/10)%10).to_s : a << " "}
    a_line2 = (1..@cfg.arg[:column_position_count]).inject([]){|a,i| i%10 == 0 ? a << " " : a << (i%10).to_s}
    printf "%s\n%s\n", a_line1.join(''), a_line2.join('')
  end

  ############################################################################
  def self.main
    puts
    conf = Config.new
    puts conf.to_s if conf.arg[:is_show_config]
    conf = nil

    game = Game.new
    ui = GameTextUI.new(game)
    input = GuessInputTextUI.new(ui.cfg.arg[:is_allow_show_phrase])

    puts ui.cfg.help[:text]
    ui.debug_show_column_position

    ui.show_preprompt_heading
    puts
    ui.show_preprompt_clue_status
    while true
      attrs = input.get_input_attrs(ui.prompt, ui.prompt_more, game.guess_list)

      case attrs[:type]
      when :guess
        game.new_guess(attrs[:data])
      when :quit
        ui.show_phrases(:pre_string => "\n")
        ui.show_score
        break
      when :show_phrase
        ui.show_phrases(:past_tense => false)
        ui.show_preprompt_padding
        next
      end

      game.calc_clues_status
      ui.show_preprompt_clue_status
      break if ui.process_game_end == :break
    end
    if ui.cfg.arg[:is_pause_at_end_game]
      printf "\nPress the Enter key to finish..."
      STDIN.readline
    end
  end

end

