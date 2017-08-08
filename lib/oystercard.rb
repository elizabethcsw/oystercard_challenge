require_relative './station.rb'

MIN_BAL = 1

class Oystercard
  attr_reader :balance
  attr_accessor :entry_station

  MAXIMUM_LIMIT = 90
  # DEFAULT_STATUS = false
  FARE_PER_TRIP = 1

  def initialize(maximum_limit = MAXIMUM_LIMIT)
    @balance = 0
    @maximum_limit = maximum_limit
    # @in_use = in_use
    @entry_station = []

  end

  def top_up(amount)
    max_error if @balance + amount > @maximum_limit
    @balance += amount
  end

  def max_error
    raise 'Max balance £90 exceeded'
  end

  def in_journey?
    return 'in use' if @entry_station != []
    'not in use'
  end

  def touch_in(station)
    raise "Insufficient funds to touch in, balance must be more than #{MIN_BAL}" if @balance < MIN_BAL
    # @in_use = true
    puts "Card touched in."
    @entry_station << station.name
  end

  def touch_out
    deduct(FARE_PER_TRIP)
    # @in_use = false
    puts "Card touched out. Remaining balance #{@balance}."
    @entry_station = []
  end

private
  def deduct(amount)
    @balance -= amount
  end
end
