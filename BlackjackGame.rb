require "Card.rb"
require "Hand.rb"
require "Shoe.rb"
require "BlackjackPlayer.rb"
require "BlackjackTable.rb"
class BlackjackGame
  attr_accessor :shoe, :dealerHand, :table, :players
  def initialize(shoe, table, players)
    @shoe = shoe
    @table = table
    @dealerHand = Array.new()
    @players = players
  end
  
  # Workhorse method, cycles through until all bets are settled
  def cycle
    # Deal cards to dealer
    # Reset dealer's hand and add two cards
    @dealerHand = Hand.new(nil)
    @dealerHand.addCard(@shoe.dealNextCard())
    @dealerHand.addCard(@shoe.dealNextCard())
    
    # Deal each player his beginning hand
    for i in 0..(@players.count - 1)
      print "\nPlayer " + (i+1).to_s() + ":"
      @players[i].newGame()
      # place player's bet (also creates the new empty hand at hands[0]
      print "\nHow much do you want to bet(<$1000)?"
      amount = gets.chomp
      @players[i].placeBet(Integer(amount))
      # Deal initial 2 cards to each player
      @players[i].getHandAtIndex(0).addCard(@shoe.dealNextCard())
      @players[i].getHandAtIndex(0).addCard(@shoe.dealNextCard())
      
      # test split
      #@players[i].getHandAtIndex(0).addCard(Card.new(1, "H"))
      #@players[i].getHandAtIndex(0).addCard(Card.new(11, "H"))
    end
    
    # Cycle through the game for each player
    for i in 0..(@players.count - 1)
      print "\nPlayer " + (i + 1).to_s() + ":"
      #print "Hands" + @players[i].getHands().count.to_s()
      counter = (@players[i].getHands().count - 1)
      j = -1
      while j < counter
        # Fill Player's hand
        @players[i].putHandAtIndex(fillHand(@players[i].getHandAtIndex(j+1), @players[i], i), j+1)
        counter = (@players[i].getHands().count - 1)
        j = j + 1
        #print "Hands" + @players[i].getHands().count.to_s()
      end
    end
    # Fill dealer's hand
    dealerFillHand()
    print "\nDealer's Hand:"
    @dealerHand.printHand()
    
    # Choose winnings or losses
    if @dealerHand.bust == true
      print "\nDealer went Bust!!"
      for i in 0..(@players.count - 1)
        for j in 0..(@players[i].getHands().count - 1)
          playerHand = @players[i].getHandAtIndex(j)
          playerTotal = playerHand.getTotal()
          playerBet = @players[i].getHandAtIndex(j).bet()
          if playerTotal < 22
            print "\nPlayer " + i.to_s() + " wins bet $" + playerBet.winningAmount().to_s()
            playerBet.moneyMadeOrLost(playerBet.winningAmount());
          else
            print "\nPlayer " + i.to_s() + " loses bet $" + playerBet.losingAmount().to_s()
            playerBet.moneyMadeOrLost(0);
          end
          @table.resolveBet(@players[i], playerHand.bet())
        end
      end
    else
      # Compare Totals for each hand and decide winning bets
      dealerTotal = @dealerHand.getTotal()
      for i in 0..(@players.count - 1)
        for j in 0..(@players[i].getHands().count - 1)
          playerHand = @players[i].getHandAtIndex(j)
          playerTotal = @players[i].getHandAtIndex(j).getTotal()
          playerBet = @players[i].getHandAtIndex(j).bet()
          if playerHand.blackjack == true
            print "\nPlayer " + i.to_s() + " wins bet $" + playerHand.bet().winningAmount().to_s()
            playerBet.moneyMadeOrLost(playerBet.winningAmount());
            next
          end
          if (playerTotal > dealerTotal) && @players[i].getHandAtIndex(j).bust == false
            print "\nPlayer " + i.to_s() + " wins bet $" + playerHand.bet().winningAmount().to_s()
            playerBet.moneyMadeOrLost(playerBet.winningAmount());
          else
            print "\nPlayer " + i.to_s() + " loses bet $" + playerHand.bet().losingAmount().to_s()
            playerBet.moneyMadeOrLost(0)
          end
        end
        @table.resolveBet(@players[i], playerHand.bet())
      end
    end

  end
  
  # Offers player a choice to hit, double-down or stand
  def fillHand(hand, player, playerIndex)
    # Print initial hand
    print "\nYour cards:"
    hand.printHand()
    print "\nYour Total:"
    print hand.getTotal()
    
    face1 = hand.getCardAtIndex(0).face
    face2 = hand.getCardAtIndex(1).face
    
    # Check if player already has 21
    if hand.getTotal == 21
      # Check for Blackjack!!
      if (face1 == "A" && (face2 == "K" || face2 == "Q" || face2 == "J")) || (face2 == "A" && (face1 == "K" || face1 == "Q" || face1 == "J"))
        print "\nBlackjack!!"
        hand.bet.betRatio = 1.5
        hand.blackjack = true
        return hand
      end
    end
    
    # Check for split option
    if face1 == face2
      print "\nWould you like to split your hand(Y/N)?"
      reply = gets.chomp
      
      # Spawn new hand if yes
      if reply.downcase == "y"
        if player.cash > hand.bet.amount
          split(hand, player, playerIndex)
          print "\nYour hand:"
          print hand.printHand()
          print "\nYour Total:"
          print hand.getTotal()
        else
          print "\nYou don't have enough cash to split!"
        end
      end
    end
    
    doubling = false
    # Run through until player stands or busts
    while hand.getTotal < 21 && doubling == false do
      # Print Dealer's Upcard
      print "\n\nDealer's hand:"
      printDealerFirstCard()
      
      if hand.bet.betRatio == 1 && player.cash >= hand.bet.amount  && doubling == false
      
        print "\nWould you like to Double Down(Y/N)?"
        reply = gets.chomp
        if reply.downcase == "y"
          temp = doublingDown(player, hand)
          #player.cash -= hand.bet.amount
          if temp != 1
            hand = temp
            doubling = true
          end
        end
       
      end
      if doubling == false
        print "\nDo you want to hit(Y/N)?"
        reply = gets.chomp
      else
        reply = "y"
      end
      if reply.downcase == "y"
        hand.addCard(@shoe.dealNextCard)
      else
        break;
      end
      print "\nYour hand:" 
      hand.printHand()
      print "\nYour Total:" + hand.getTotal().to_s()
    end
    
    # Check status
    if hand.getTotal <= 21
      print "\nYour final total is " + hand.getTotal.to_s()
    elsif hand.getTotal > 21
      print "\nBust!"
      hand.bust = true
    end
    return hand
  end
  
  # Split a given hand for a given player
  def split(hand, player, playerIndex)
    # Remove 1 card and create a new hand with a similar bet
    card = hand.removeCard(0)
    player.placeBet(hand.bet.amount, card)
    #print "Hands:" + player.hands.count.to_s()
    
    # Fill up the two hands
    hand.addCard(@shoe.dealNextCard())
    hand1 = player.getHandAtIndex(player.bets - 1)
    hand1.addCard(@shoe.dealNextCard())
    @players[playerIndex] = player
  end
  
  # Double the bet
  def doublingDown(player, hand)
    if player.cash < hand.bet.amount
      print "\nYou don't have enough cash to double down!!"
      return 1
    end
    player.cash = player.cash - hand.bet.amount
    hand.bet.amount = 2 * hand.bet.amount;
    return hand
  end
  # Dealer Specific Methods
  # Display dealer's 1st card
  def printDealerFirstCard 
    @dealerHand.getCardAtIndex(0).printCard()
  end
  
  def dealerFillHand
    while @dealerHand.getTotal() < 17 do
      @dealerHand.addCard(@shoe.dealNextCard())
    end 
    # Check if dealer went bust
    if @dealerHand.getTotal > 21
      @dealerHand.bust = true
    end
  end
end