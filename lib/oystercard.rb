require_relative './station.rb'
require_relative './journey.rb'

MIN_BAL = 1

class Oystercard
  attr_reader :balance, :journeys_log
  attr_accessor :entry_station, :trip_no

  MAXIMUM_LIMIT = 90

  def initialize(maximum_limit = MAXIMUM_LIMIT)
    @balance = 0
    @maximum_limit = maximum_limit
    @journeys_log = []
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
    @journeys_log << Journey.new(station)
    puts "Card touched in. Remaining balance #{@balance}."
  end

  def touch_out(station)
    @journeys_log << Journey.new(nil) if first_trip || touched_out
    @journeys_log.last.finish(station)
    deduct(@journeys_log.last.fare)
    puts "Card touched out. Remaining balance #{@balance}."
  end

private
  def check_sufficient_fund
    raise "Insufficient funds, min requried balance is #{MIN_BAL}" if @balance < MIN_BAL
  end

  def faulty_touch_in
    deduct(Journey::PENALTY_FARE)
    puts "Penalty of £6 charged because previous journey was not touched out"
  end

  def first_trip
    @journeys_log.count.zero?
  end

  def max_error
    raise 'Max balance £90 exceeded'
  end

  def touched_in
    !first_trip && @journeys_log.last.out.nil?
  end

  def touched_out
    !first_trip && !@journeys_log.last.in.nil? && !@journeys_log.last.out.nil?
  end

  def deduct(amount)
    @balance -= amount
  end
end
