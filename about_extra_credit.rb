# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.


class Greed
  attr_accessor :players
  attr_accessor :player_names
  attr_accessor :player_turn

  def initialize(player_names)
    @players = Hash.new(default=0)
    @player_names = Array.new(player_names)
    @player_turn = 0 # first player turn
  end

  def to_s
    puts "Game Standings"
    # order players by score
    i = 0
    standings = []
    while i<player_names.count
      @players.each { |name, score|
        next if standings.member?(name)
        next_place = ( @players[next_place] < score ? name : next_place )
      }
      standings << next_place
      puts "#{i + 1}.- #{next_place}, #{@players[next_place]} points."
      i += 1
    end
  end

  def play
    best_score = 0
    while best_score < 3000
      turn = Turn.new
      player = @player_names[@player_turn]
      turn.play
      players[player] += turn.score
      best_score = ( best_score < players[player] ? players[player] : best_score )
      @player_turn = (@player_turn + 1 ) % player_names.count
    end
    last_turn
    puts "#{self}"
  end

  def last_turn
    @players.each { |name, score|
      next if score >= 3000
      turn = Turn.new
      turn.play
      @players[name] += turn.score
    }
  end

end

class Turn
  attr_reader :score
  attr_reader :dice

  def initialize
    @score = 0
    @continue = "yes"
    @dice = 5
  end

  def to_s
    puts "score: #{@score}"
  end

  def play
    dice = DiceSet.new
    while @dice > 0 and @continue.downcase == "yes"
      puts "You have #{@dice} dice"
      dice.roll(@dice)
      dice.calculate_score
      @score += dice.score
      @dice = dice.non_scoring

      if  dice.score == 0
        @score = 0
        @continue = "no"
      end

      # Show values, score and ask if user wants to
      # continue throwing @dice dice.
      puts "THROW RESULT"
      puts "#{dice.to_s}"
      puts "TURN INFO"
      puts "#{self.to_s}\n"
      puts "You have #{@dice} non-scoring dice. Keep throwing?" if @dice > 0
      @continue = STDIN.gets
      @continue = "no" unless @dice > 0
    end
  end

end

# DICESET class
# values only last one roll
# Allows me to: roll N dice, get # of non-scoring dice, get roll score
#
class DiceSet
  attr_reader :values
  attr_reader :score
  attr_reader :count #Hash with number of appearances per number (1 - 6)

  def initialize
    @values = []
    @rand = Math.const_get(:E)
    @score = 0
  end

  def to_s
    puts "Dice thrown: #{@values.join(", ")}"
    puts "Score: #{@score}"
  end

  def roll(rolls)
    @values = Array.new(rolls)
    i = 0
    for d in @values
     while d == nil or d > 6 or d < 1
       d = @rand.truncate
       @rand -= d
       random
     end
     @values[i] = d
     i += 1
    end
  end

  def random
    @rand *= rand * 10
  end

  def calculate_score()
    # return score
    @count = Hash.new(0)
    @score = 0
    i = 0
    while i < @values.size
      d = @values[i]
      @count[d] += 1
      if @count[d] == 3
        @count[d] = 0
        if d == 1
          @score += 1000
        else
          @score += d*100
        end
      end
      i+=1
    end
    @score += @count[1] * 100
    @score += @count[5] * 50
  end

  def non_scoring()
    non_scoring = 0
    key = 1
    while key < 6
      key += 1
      next if key == 5
      non_scoring += 1 unless @count[key] >= 3
    end
    return non_scoring
  end

end

game = Greed.new (["beto","hugo"])
game.play
