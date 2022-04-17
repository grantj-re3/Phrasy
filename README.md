# Phrasy

This game is a variant of the game
[hangman](https://en.wikipedia.org/wiki/Hangman_(game)). It allows
some of the game's features to be customised via a configuration file.

This game uses a text user interface. It has been tested using Linux
and does not use any special character graphics or colours so may work
on any platform. I have not tested under Mac OS X or Windows.

You need to install ruby (if not already installed). I imagine
the program will work using any Ruby 2.x version. It has been tested
using the following Ruby versions: 2.3.3 & 2.6.3.


## How to play

The game of Phrasy is a phrase-guessing game. In each game you are
trying to guess a secret phrase. E.g. EVERY CLOUD HAS A SILVER LINING.

- The game starts by displaying the phrase with a dot where each
  letter would appear.
- For each guess, enter a single letter or a sequence of letters.
- You have limited number of guesses.
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


## Configuration

The file phrasy_cfg.rb allows you to configure:

- the maximum number of guesses permitted
- various text formatting arrangements
- the phrase list file


## To run

After downloading/unzipping (or git-clone)...

```
$ cd Phrasy
$ chmod 755 mw.rb   # Once only; make the main file executable
$ ./phrasy.rb       # Run
```

or

```
$ cd Phrasy
$ ruby phrasy.rb    # Run
```

Note that I have used '$' above to represent the Linux command
line prompt. You should not type the '$' sign above.

