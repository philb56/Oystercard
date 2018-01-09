class Oystercard
  attr_reader :balance, :journeys, :journey
  BALANCE_LIMIT = 90
  MINIMUM_REQUIREMENT = 1

  def initialize
    @balance = 0
    @journeys = []
    @journey = {entry: nil, exit: nil}
  end

  def top_up(amount)
    message = "£#{amount} top up failed, balance will exceed £#{BALANCE_LIMIT}"
    raise message if maximum_exceeded?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Insufficient funds" if @balance < MINIMUM_REQUIREMENT
    @journey[:entry] = entry_station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_REQUIREMENT)
    store_journey(@journey[:entry], exit_station)
    @journey[:exit] = nil
    @journey[:entry] = nil
  end

  def in_journey?
    !!@journey[:entry]
  end

  def store_journey(entry_station, exit_station)
    journey[:exit] = exit_station
    journeys << {entry: entry_station, exit: exit_station}
  end

private
  def maximum_exceeded?(amount)
    balance + amount > BALANCE_LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end
end
