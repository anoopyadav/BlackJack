require "Card.rb"
class Hand
  attr_accessor :cards, :hardTotal, :softTotal, :numOfAces, :bet, :bust, :blackjack
  # Constructor
  def initialize(bet, card = nil)
    @bet = bet
    @bust = false
    if card == nil
      @cards = Array.new()
      @hardTotal = 0
      @softTotal = 0
      @numOfAces = 0
    else
      @cards = [card]
      @hardTotal = card.hard()
      @softTotal = card.soft()
      if card.face == "A"
        @numOfAces = 1
      else
        @numOfAces = 0
      end
    end
  end
  
  # Add a new card to the current hand
  def addCard(card)
    @cards.push(card)
    @hardTotal += card.hard()
    @softTotal += card.soft()
    if card.face == "A"
      @numOfAces += 1
    end
  end
  
  # Get Card at index
  def getCardAtIndex(index)
    return @cards[index]
  end
  
  # Delete card from hand (in case of split)
  def removeCard(index)
    card = @cards.delete_at(index)
    @hardTotal -= card.hard()
    @softTotal -= card.soft()
    if card.face == "A"
      @numOfAces -= 1
    end
    return card
  end
    
  # Which total to use: This is the total used to settle bets
  def getTotal
    # always start with the soft total
    total = @softTotal
    
    # if there is more than 1 Ace, only 1 will be used as 11
    # all others count for 1
    if @numOfAces >= 2
      total = 10 + @hardTotal
    # if the Ace is putting us over 21, count as 1
    elsif @numOfAces == 1 && @softTotal > 21
      total = @hardTotal
    end 
    # If softTotal is over 21, use hardTotal
    if total > 21
      total = @hardTotal
    end
    return total
  end  
  
  # Associate the hand with a bet placed by the player
  def setBet(bet)
    @bet = bet
  end
  
  # Print hand contents
  def printHand
    for i in 0..@cards.count - 1
      @cards[i].printCard
    end
  end
end

#hand = Hand.new(Card.new(9,"S"))
#hand.addCard(Card.new(8, "C"))
#hand.addCard(Card.new(1, "D"))
##hand.addCard(Card.new(12,"H"))
#puts hand.getTotal