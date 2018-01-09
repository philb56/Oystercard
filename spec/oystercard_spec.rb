require 'oystercard'

describe Oystercard do
  subject :oystercard  { described_class.new }
  let (:entry_station) { double :entry_station, name: 'Barking' }
  let (:exit_station) { double :exit_station, name: 'Reading' }

  describe "assorted checks:" do
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

    it 'should have in_journey?' do
      expect(oystercard.in_journey?).to eq false
    end

    it 'should allow user to touch out' do
      oystercard.touch_out(exit_station.name)
      expect(oystercard.in_journey?).to eq(false)
    end

    it 'should raise an error if a card has less than the minimum balance' do
      expect{oystercard.touch_in(entry_station.name)}.to raise_error "Insufficient funds"
    end

  end

  describe "top-up" do

    before(:example) do
      oystercard.top_up(1)
    end

    it 'should deduct £1 from balance when touch out' do
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_REQUIREMENT)
    end

    it 'should deduct £1 from £2 balance when touch out' do
      oystercard.top_up(1)
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_REQUIREMENT)
    end

  end
  describe "top-up, touch in" do

    before(:example) do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
    end

    it "should remember entry station after touch in" do
      expect(oystercard.journey[:entry]).to eq 'Barking'
    end

    it 'should say if oystercard is in_journey?' do
      expect(oystercard).to be_in_journey
    end

    it 'should allow user to touch in' do
      expect(oystercard.journey[:entry]).to eq(entry_station.name)
    end

  end

  describe "top-up, top in, touch out" do
    before(:example) do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station.name)
      oystercard.touch_out(exit_station.name)
    end

    it "should forget entry station after touch out" do
      expect(oystercard.journey[:entry]).to be nil
    end

    it "Should add the completed journey after touch out" do
      expect(oystercard.journeys).to include( {entry: entry_station.name, exit: exit_station.name} )
    end

    it 'should say if oystercard is not in_journey?' do
      expect(oystercard).not_to be_in_journey
    end
  end
end
