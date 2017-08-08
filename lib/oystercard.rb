#
class Oystercard
  attr_reader :balance
  attr_accessor :in_use

  MAXIMUM_LIMIT = 90
  DEFAULT_STATUS = false

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

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    return 'not in use' unless @in_use
    'in use'
  end

  def touch_in
    @in_use = true
  end

  def touch_out
    @in_use = false
  end
end
