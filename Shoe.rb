require "Deck.rb"
class Shoe
  attr_accessor :numOfDecks, :shoe, :index, :stopDeal
  # Constructor: Initializes the shoe with a given number of decks
  def initialize(noOfDecks, stop)
    # Stop dealing cards at this point
    @stopDeal = stop * 52
    #Total number of decks
    @numOfDecks = noOfDecks
    # Create an empty show container
    @shoe = Array.new
    # Obtain new decks, then insert individual cards into the shoe
    for i in 1..@numOfDecks
      @shoe |= Deck.new().deckOfCards()
    end
  end
  
  # Shuffle the contents of shoe
  # Placeholder: Calls the Array.Shuffle method, room for improvement
  def shuffle
    # Pointer to the next available card
    @index = -1
    @shoe = @shoe.shuffle
  end
  
  # Deal next card
  def dealNextCard
    @index = @index + 1
    return @shoe[@index]
  end
  
  # Check if dealer has cards left in shoe
  def hasCards
    if @index > @stopDeal
      return true
    else
      return false
    end
  end
end

# Unit Test
#shoe = Shoe.new(4, 1)
#shoe.shuffle()
#for i in 0..shoe.shoe().count() - 1
#  shoe.shoe[i].printCard()
#end
#puts "Next Card"
#puts shoe.dealNextCard.printCard