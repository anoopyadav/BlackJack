require "Hand.rb"
require "BlackjackTable.rb"
require "Bet.rb"
class BlackjackPlayer
  attr_accessor :table, :hands, :cash, :bets, :amount
  def initialize(table)
    @table = table
    @hands = Array.new()
    @cash = 1000.0
    @bets = 0
  end
  
  def placeBet(amount, card = nil)
    # Get user input for initial bet
    if card == nil
      bet = Bet.new(amount)
      @cash = @cash - amount
      @hands.push(Hand.new(bet))
      @table.placeBet(bet, @hands[0])
      @bets = @bets + 1
    else
      bet = Bet.new(amount)
      @cash = @cash - amount
      @hands.push(Hand.new(bet,card))
      @table.placeBet(bet, @hands[@bets])
      @bets = @bets + 1
    end
    
  end
  
  # Get a reference to hands
  def getHands
    return @hands
  end
  
  # Gets a specific hand from player
  def getHandAtIndex(index)
    return @hands[index]
  end
  
  # Put a hand from player
  def putHandAtIndex(hand, index)
    @hands[index] = hand
  end
  
  # Resets player's list of hands
  def newGame
    @hands = Array.new
  end
end