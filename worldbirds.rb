#!/usr/bin/ruby
#
# Copyright (C) 2022 Grant Jackson
# Licensed under GPLv3. http://www.gnu.org/licenses/gpl-3.0.html
#
# Environment: Ruby 2.x
#
##############################################################################
# The file to run to play the game
##############################################################################
ParentDir = File.expand_path(".", File.dirname(__FILE__))
ConfigFilename = "#{File.basename(__FILE__, '.rb')}_cfg.rb"
ConfigFilepath = "#{ParentDir}/#{ConfigFilename}"
PhraseFilesDir   = "#{ParentDir}/phrasefiles"

# Add dirs to the library path
$: << "#{ParentDir}/lib"

require ConfigFilepath if File.readable?(ConfigFilepath)
require "game_text_ui.rb"

##############################################################################
### Main
##############################################################################
GameTextUI.main

