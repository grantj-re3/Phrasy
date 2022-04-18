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
- The "Untried letters" column only shows *individual* letters (not
  sequences) which have not yet been attempted during the game.


## Configuration

The file phrasy_cfg.rb allows you to configure:

- the maximum number of guesses permitted
- various text formatting arrangements
- the phrase list file


## To run

After downloading/unzipping (or git-clone)...

```
$ cd Phrasy
$ chmod 755 phrasy.rb   # Once only; make the main file executable
$ ./phrasy.rb           # Run
```

or

```
$ cd Phrasy
$ ruby phrasy.rb        # Run
```

Note that I have used '$' above to represent the Linux command
line prompt. You should not type the '$' sign above.


## Screenshot of the Phrasy game

![Screenshot of Phrasy game](/assets/images/phrasy1d.png)


## How to add a new program with a new phrase list

Let's say that you want to create an additional phrasy game with:

- program name: *movies.rb*
- it's own configuration file: *movies_cfg.rb*
- phrase list filename: *kids_movies.txt*

then this is how you do it!

1.  Add the new phrase-list file, kids_movies.txt to the folder "phrasefiles"
    - One phrase per line
    - Only letters A to Z and space characters permitted. For example, remove
      commas, fullstops, quotation marks, smart quotes and replace hyphens
      with spaces.
    - Note that the program will force all lower case letters to capital
      letters.

```
$ cd Phrasy
$ cp -vip /PATH/TO/kids_movies.txt phrasefiles
```

2.  Copy the program file

```
$ cp -vip phrasy.rb movies.rb
```

3.  Copy the configuration file

    The configuration filename ***must*** comply with the following rule:
    If the new program name were *MYPROG.rb*, then the corresponding config
    file would be *MYPROG_cfg.rb*.

```
$ cp -vip phrasy_cfg.rb movies_cfg.rb
```

4.  Point to the phrase-list file within the configuration.

    In the section:

```
    @phrasefiles = { ... }
```

    change the filename line to:

```
    nil => "kids_movies.txt",
```

5.  Change any other features within the configuration file as desired.

