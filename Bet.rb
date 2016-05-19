class Bet
  attr_accessor :amount, :betRatio, :cash
  def initialize(amt)
    @amount = amt
    @betRatio = 1.0
  end
  
  # Return winning amount
  def winningAmount  
    # Blackjack Payoff
    if @betRatio == 1.5
      return (@amount * @betRatio)
    else
      return (@amount * @betRatio *2)
    end
  end
  
  # Return loosing amount
  def losingAmount
    return @amount
  end
  
  def moneyMadeOrLost(cash)
    @cash = cash
  end
  def doubleDown
    @amount = @amount * 2.0
    @betRatio = 1.0
  end
end