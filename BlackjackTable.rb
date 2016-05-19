require "Bet.rb"
require "Hand.rb"
class BlackjackTable
  attr_accessor :bets
  # Initialize an empty table
  def initialize
    @bets = Array.new()
  end
  
  # Place a bet on the given hand
  def placeBet(bet, hand)
    @bets.push(bet)
    hand.setBet(bet)
  end
  
  # Settle bets
  def resolveBet(player, bet)
    player.cash += bet.cash
  end
end