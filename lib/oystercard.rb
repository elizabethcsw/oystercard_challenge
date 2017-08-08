MIN_BAL = 1

class Oystercard
  attr_reader :balance
  attr_accessor :in_use

  MAXIMUM_LIMIT = 90
  DEFAULT_STATUS = false
  FARE_PER_TRIP = 1

  def initialize(maximum_limit = MAXIMUM_LIMIT, in_use = DEFAULT_STATUS)
    @balance = 0
    @maximum_limit = maximum_limit
    @in_use = in_use

  end

  def top_up(amount)
    max_error if @balance + amount > @maximum_limit
    @balance += amount
  end

  def max_error
    raise 'Max balance £90 exceeded'
  end

  def in_journey?
    return 'not in use' unless @in_use
    'in use'
  end

  def touch_in
    raise "Insufficient funds to touch in, balance must be more than #{MIN_BAL}" if @balance < MIN_BAL
    @in_use = true
    "Card touched in."
  end

  def touch_out
    deduct(FARE_PER_TRIP)
    @in_use = false
    "Card touched out. Remaining balance #{@balance}."
  end

private
  def deduct(amount)
    @balance -= amount
  end
end
