require 'spec_helper.rb'

describe 'Auction' do
  let(:user) { create(:user) }
  let(:user_session) { { 'rack.session' => { user_id: user.id } } }
  let(:auction) { create(:auction) }
  let(:bid) { create(:bid) }
  describe 'GET /auctions' do
    before do
      get '/auctions', {}, user_session
    end

    context 'user is not logged in' do
      let(:user_session) { {} }
      it 'shows auctions' do
        get '/auctions'
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Auctions')
      end
    end
  end

  describe 'GET /auctions/new' do
    context 'user is not logged in' do
      let(:user_session) { {} }
      it 'works not logged in' do
        get '/auctions/new'
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq 'http://example.org/login'
      end
    end

    context 'user is logged in' do
      it 'works' do
        get '/auctions/new', {}, user_session
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('New Auction')
      end
    end
  end

  describe 'POST /auctions' do
    it 'when works redirects and shows flash' do
      post '/auctions', { auction: { title: 'title', description: 'abcde' * 5 } }, user_session
      expect(last_response.status).to eq 302
      expect(last_response.location).to eq 'http://example.org/auctions/new'
      expect(last_request.session[:flash][:success]).to include('Your auction title has been created.')
    end

    it 'when it doesn\'t renders form with current values and flash' do
      post '/auctions', { auction: { title: 'ti', description: 'abcde' } }, user_session
      expect(last_response.status).to eq 200
      expect(last_response.body).to include 'Auction ti cannot be saved. Please check your data and submit again.'
    end
  end

  describe 'GET /auctions/:id' do
    context 'user is logged in' do
      let(:user_session) { { 'rack.session' => { user_id: auction.user.id } } }
      let(:bid) { create(:bid) }
      it 'works when no bids' do
        get "/auctions/#{auction.id}", {}, user_session
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Back to Auctions')
      end

      it 'works when bids' do
        get "/auctions/#{auction.id}", {}, user_session
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Back to Auctions')
      end

      it 'shows max bid + 1' do
        get "/auctions/#{bid.auction.id}", {}, user_session
        bid.amount + 1
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Place bid')
      end
    end
  end

  describe 'GET /auctions/:id/edit' do
    context 'user is logged in' do
      let(:auction) { create(:auction) }
      let(:user_session) { { 'rack.session' => { user_id: auction.user.id } } }
      it 'shows only if current user can edit' do
        get "/auctions/#{auction.id}/edit", {}, user_session
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Back to Auctions')
      end

      it 'if cannot, 404' do
        get "/auctions/#{auction.id}/edit", {}, user_session
        auction.id != user.id
        expect(404)
      end

      it 'works' do
        get "/auctions/#{auction.id}/edit", {}, user_session
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'PUT /auctions/:id' do
    context 'user is logged in' do
      let(:auction) { create(:auction) }
      it '403 or flash & redirect if user cannot update the auction' do
        # binding.pry
        put "/auctions/#{auction.id}", auction: { title: 'title', description: 'abcd' * 5 }
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq "http://example.org/auctions/#{auction.id}"
        expect(last_response.body).to include('flash-message')
      end

      it 'when it works shows forms with current values & flash' do
        put "/auctions/#{auction.id}", auction: { title: 'title', description: 'abcd' * 5 }
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('flash-message')
      end

      it 'when it doesn\'t works shows wrong values & flash' do
        put "/auctions/#{auction.id}", auction: { title: 't', description: 'abcd' * 5 }
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('flash-message')
      end
    end
  end
end
