class Oystercard
  attr_reader :balance, :entry_station
  BALANCE_LIMIT = 90
  MINIMUM_REQUIREMENT = 1

  def initialize
    @balance = 0
    @entry_station = nil
  end

  def top_up(amount)
    message = "£#{amount} top up failed, balance will exceed £#{BALANCE_LIMIT}"
    raise message if maximum_exceeded?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Insufficient funds" if @balance < MINIMUM_REQUIREMENT
    # raise "No entry_station" if entry_station.nil
    @entry_station = entry_station
  end

  def touch_out
    deduct(MINIMUM_REQUIREMENT)
    @entry_station = nil
  end

  def in_journey?
    !!@entry_station
  end

private
  def maximum_exceeded?(amount)
    balance + amount > BALANCE_LIMIT
  end

  def deduct(amount)
    @balance -= amount
  end
end
