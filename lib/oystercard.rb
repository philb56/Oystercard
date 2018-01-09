class Oystercard
  attr_reader :balance, :entry_station, :journeys, :exit_station
  BALANCE_LIMIT = 90
  MINIMUM_REQUIREMENT = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @exit_station = nil
    @journeys = []
  end

  def top_up(amount)
    message = "£#{amount} top up failed, balance will exceed £#{BALANCE_LIMIT}"
    raise message if maximum_exceeded?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Insufficient funds" if @balance < MINIMUM_REQUIREMENT
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(MINIMUM_REQUIREMENT)
    @entry_station = nil
    @exit_station = exit_station
    store_journey(@entry_station, @exit_station)
  end

  def in_journey?
    !!@entry_station
  end

  def store_journey(entry_station, exit_station)
    journeys << Hash.new(entry: entry_station, exit: exit_station)
  end

private
  def maximum_exceeded?(amount)
    balance + amount > BALANCE_LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end
end
