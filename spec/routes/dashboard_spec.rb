require 'spec_helper.rb'

describe 'Dashboard' do
  describe 'GET /dashboard' do
    let(:user) { create(:user) }
    let(:user_session) { { 'rack.session' => { user_id: user.id } } }
    context 'user is not logged in' do
      let(:user_session) { {} }
      it 'redirects to login when not logged in' do
        get '/dashboard'
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq 'http://example.org/login'
      end
    end

    context 'user is logged in' do
      let(:auction) { create(:auction) }
      it 'works when there are not auctions' do
        get '/dashboard', {}, user_session
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Welcome')
      end

      it 'works when there are auctions' do
        get '/dashboard', {}, user_session
        auction
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Welcome')
      end
    end
  end
end
