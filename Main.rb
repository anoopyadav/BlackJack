require "Shoe.rb"
require "BlackjackTable.rb"
require "BlackjackPlayer.rb"
require "BlackjackGame.rb"

# Initialize the game components
shoe = Shoe.new(8,2)
shoe.shuffle()
table = BlackjackTable.new()
print "Welcome to Blackjack v1.0"
print "\nHow many players at the table?"
num = gets.chomp
players = Array.new()
for i in 0..(Integer(num) - 1)
  player = BlackjackPlayer.new(table)
  players.push(player)
end
game = BlackjackGame.new(shoe,table,players)
game.cycle()
for i in 0..Integer(num)-1
  print "\nPlayer " + (i+1).to_s() + " Cash in Pocket:$" + "#{players[i].cash}"
end
print "\nThank You for playing!!\n"
