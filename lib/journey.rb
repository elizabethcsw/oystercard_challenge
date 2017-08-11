class Journey
  PENALTY_FARE = 6
  FARE_PER_TRIP = 2

  attr_accessor :in, :out

  def initialize(in_station=nil)
    @in = in_station
    @out = nil
  end

  def fare
    return FARE_PER_TRIP if complete?
    PENALTY_FARE
  end

  def finish(station)
    @out = station
  end

  def complete?
    !(@in && @out).nil?
  end
end
