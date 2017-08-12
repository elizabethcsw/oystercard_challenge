require_relative './station.rb'
require_relative './journey.rb'
require_relative './journeylog.rb'

MIN_BAL = 1

class Oystercard
  attr_reader :balance, :journeys_log
  attr_accessor :entry_station, :trip_no

  MAXIMUM_LIMIT = 90

  def initialize(maximum_limit = MAXIMUM_LIMIT)
    @balance = 0
    @maximum_limit = maximum_limit
    @journeys_log = JourneyLog.new
  end

  def top_up(amount)
    max_error if @balance + amount > @maximum_limit
    @balance += amount
  end

  def in_journey?
    return 'in use' if touched_in
    'not in use'
  end

  def touch_in(station)
    check_sufficient_fund
    faulty_touch_in if touched_in
    @journeys_log.start(station)
    "Card touched in. Remaining balance #{@balance}."
  end

  def touch_out(station)
    @journeys_log.start(nil) if first_trip || touched_out
    @journeys_log.finish(station)
    deduct(@journeys_log.latest_journey.fare)
    "Card touched out. Remaining balance #{@balance}."
  end

private
  def check_sufficient_fund
    raise "Insufficient funds, min requried balance is #{MIN_BAL}" if @balance < MIN_BAL
  end

  def faulty_touch_in
    deduct(Journey::PENALTY_FARE)
    "Penalty of £6 charged because previous journey was not touched out"
  end

  def first_trip
    @journeys_log.journeys.count.zero?
  end

  def max_error
    raise 'Max balance £90 exceeded'
  end

  def touched_in
    !first_trip && @journeys_log.latest_journey.out.nil?
  end

  def touched_out
    !first_trip && !@journeys_log.latest_journey.in.nil? && !@journeys_log.latest_journey.out.nil?
  end

  def deduct(amount)
    @balance -= amount
  end

end
