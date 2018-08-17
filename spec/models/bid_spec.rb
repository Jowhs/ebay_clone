require 'spec_helper.rb'

describe Bid do
  let(:bid) { create(:bid) }
  let(:user) { create(:user) }

  describe 'bid validation' do
    it 'cannot be 0 or less' do
      bid = create(:bid, amount: -100)
      expect(bid.errors.on(:amount)).to include('Please introduce a valid number.')
    end

    it 'cannot bid own auctions' do
      auction = create(:auction, user: user)
      bid = create(:bid, user: user, auction: auction)
      expect(bid.errors.on(:amount)).to include('You cannot bid your own auction.')
    end

    it 'new bid higher' do
      auction = create(:auction)
      create(:bid, amount: 2000, auction: auction)
      bid2 = create(:bid, amount: 1000, auction: auction)
      expect(bid2.errors.on(:amount)).to include('New bid must be higher than current bid.')
    end
  end
end
