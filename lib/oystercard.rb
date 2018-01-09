class Oystercard
  attr_reader :balance, :in_use
  BALANCE_LIMIT = 90

  def initialize
    @balance = 0
    @in_use = nil
  end

  def top_up(amount)
    message = "£#{amount} top up failed, balance will exceed £#{BALANCE_LIMIT}"
    raise message if maximum_exceeded?(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    @in_use = true
  end

  def touch_out
    @in_use = false
  end

  def in_journey?
    @in_use
  end

  private
  def maximum_exceeded?(amount)
    balance + amount > BALANCE_LIMIT
  end

end
