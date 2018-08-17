require 'spec_helper.rb'

describe 'Bid' do
  describe 'POST /auctions/:id/bids' do
    let(:auction) { create(:auction) }
    let(:user) { create(:user) }
    let(:bid) { create(:bid) }
    let(:user_session) { { 'rack.session' => { user_id: user.id } } }

    it 'when works show flash and redirect' do
      post "/auctions/#{auction.id}/bids", { bid: { amount: 3000 } }, user_session
      expect(last_response.status).to eq 302
      expect(last_response.location).to eq "http://example.org/auctions/#{auction.id}"
      expect(last_request.session[:flash][:success]).to include('Your bid has been sended.')
    end

    it 'doesn\'t work, flash and render' do
      post "/auctions/#{auction.id}/bids", { bid: { amount: -1 } }, user_session
      expect(last_response.status).to eq 200
      expect(last_response.body).to include('New bid must be higher than current bid.')
    end
  end
end
