require "Card.rb"
class Deck
  @@numOfCards = 52
  attr_accessor :deckOfCards
  
  # initialize the deck
  def initialize
    # Empty deck
    @deckOfCards = Array.new
    suites = ["D", "H", "C", "S"]
    # fill up for each suite
    suites.each do|suite|
      for i in 1..13
        @deckOfCards.push(Card.new(i,suite))
      end
    end
  end
  
  # Debug Method
  def printDeck
    #puts "Size of Deck" + @deckOfCards.count().to_s()
    for i in 0..51
      print @deckOfCards[i].printCard()
    end
  end 
end

# Unit Test
#deck = Deck.new()
#deck.printDeck()