require_relative './station.rb'

MIN_BAL = 1

class Oystercard
  attr_reader :balance, :journeys
  attr_accessor :entry_station, :trip_no

  MAXIMUM_LIMIT = 90
  FARE_PER_TRIP = 1

  def initialize(maximum_limit = MAXIMUM_LIMIT)
    @balance = 0
    @maximum_limit = maximum_limit
    @journeys = []
    @trip_no = 0
  end

  def top_up(amount)
    max_error if @balance + amount > @maximum_limit
    @balance += amount
  end

  def max_error
    raise 'Max balance £90 exceeded'
  end

  def in_journey?
    return 'not in use' if @journeys == []
    return 'in use' if touched_in && !touched_out
    return 'not in use' if last_journey_complete
  end

  def touch_in(station)
    raise "You cannot touch in twice" if @trip_no > 0 && (touched_in || !touched_out)
    @trip_no += 1
    raise "Insufficient funds, min requried balance is #{MIN_BAL}" if @balance < MIN_BAL
    puts "Card touched in."
    @journeys << { in: station.name, in_zone: station.zone, out: "nil", out_zone: "nil" }
  end

  def touch_out(station)
    raise "Please touch in first" if touched_out || !touched_in
    deduct(FARE_PER_TRIP)
    # @in_use = false
    puts "Card touched out. Remaining balance #{@balance}."
    @journeys[trip_no - 1][:out] = station.name
    @journeys[trip_no - 1][:out_zone] = station.zone
  end

private
  def touched_in
    @journeys.last[:in] != "nil"
  end

  def touched_out
    @journeys.last[:out] != "nil"
  end

  def last_journey_complete
    touched_in && touched_out
  end

  def deduct(amount)
    @balance -= amount
  end
end
