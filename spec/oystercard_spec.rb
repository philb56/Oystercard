require 'oystercard'

describe Oystercard do
  subject :oystercard  { described_class.new }
  let (:entry_station) { double :entry_station, name: 'Barking' }

  context "balance checks:" do
    it "check oystercard balance" do
      expect(oystercard.balance).to eq 0
    end

    it "check top up adds to balance" do
      expect(oystercard.top_up(2)).to eq 2
    end

    it "check top up amount adds same amount to balance" do
      expect{oystercard.top_up(1)}.to change{ oystercard.balance}.by 1
    end

    it "check top up is capped" do
      max_balance = Oystercard::BALANCE_LIMIT
      amount = max_balance + 1
      expect{oystercard.top_up(amount)}.to raise_error "£#{amount} top up failed, balance will exceed £#{max_balance}"
    end

    it 'should have in_journey? attribute' do
      expect(oystercard.in_journey?).to eq false
    end

    it 'should allow user to touch in' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
      expect(oystercard.in_journey?).to eq(true)
    end

    it 'should allow user to touch out' do
      oystercard.touch_out
      expect(oystercard.in_journey?).to eq(false)
    end

    it 'should say if oystercard is in_journey?' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
      expect(oystercard).to be_in_journey
    end

    it 'should say if oystercard is not in_journey?' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
      oystercard.touch_out
      expect(oystercard).not_to be_in_journey
    end

    it 'should raise an error if a card has less than the minimum balance' do
      expect{oystercard.touch_in(entry_station.name)}.to raise_error "Insufficient funds"
    end

    it 'should deduct £1 from balance when touch out' do
      oystercard.top_up(1)
      expect{oystercard.touch_out}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_REQUIREMENT)
    end

    it 'should deduct £1 from £2 balance when touch out' do
      oystercard.top_up(2)
      expect{oystercard.touch_out}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_REQUIREMENT)
    end

    it "should remember entry station after touch in" do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
      expect(oystercard.entry_station).to eq 'Barking'
    end

    it "should forget entry station after touch out" do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
      oystercard.touch_out
      expect(oystercard.entry_station).to be nil
    end
  end
end
