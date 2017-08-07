#
class Oystercard
  attr_reader :balance

  MAXIMUM_LIMIT = 90

  def initialize(maximum_limit = MAXIMUM_LIMIT)
    @balance = 0
    @maximum_limit = maximum_limit
  end

  def top_up(amount)
    max_error if @balance + amount > @maximum_limit
    @balance += amount
  end

  def max_error
    raise 'Max balance of £90 is exceeded'
  end
end
