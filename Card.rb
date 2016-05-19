class Card
  attr_accessor :suite, :face, :hard, :soft
  # Constructor, creates a new Card with suite and value
  def initialize(value, suite)
    @suite = suite
    if value == 1
      @hard = 1
      @soft = 11
      @face = "A"
    elsif value > 10
      @value = 10
      @hard = 10
      @soft = 10
      if value == 11
        @face = "K"
      elsif value == 12
        @face = "Q"
      elsif value == 13
        @face = "J"
      end
    else
      @hard = value
      @soft = value
      @face = value
    end
  end
  
  # Print the Card's contents
  def printCard
    print "" + face.to_s() + suite + " "
  end
end