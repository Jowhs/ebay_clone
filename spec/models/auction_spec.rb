require 'spec_helper.rb'

describe Auction do
  describe 'auction creation' do
    let(:auction) { build(:auction) }

    context 'user is logged in' do
      it 'cannot create an auction without title' do
        auction.title = nil
        expect(auction).to_not be_valid
      end

      it 'cannot create an auction without description' do
        auction.description = nil
        expect(auction).to_not be_valid
      end
    end
  end
end
