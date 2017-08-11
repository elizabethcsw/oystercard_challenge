class JourneyLog



  def initialize(journey_class= Journey)
    @journey_class = journey_class
    @log = []
  end

  def start(entry_station)
    @log << @journey_class.new(entry_station)
  end

  def current_journey
    @log << @journey_class.new if @log.last.complete?
    @log.last
  end

  def finish(exit_station)
    current_journey.out = exit_station
  end

  def journeys
    @log.dup
  end

  def latest_journey
    @log.last
  end

end
