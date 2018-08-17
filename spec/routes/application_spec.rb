require 'spec_helper.rb'

describe 'Application' do
  describe 'GET /' do
    before do
      get '/', {}, user_session
    end

    let(:user) { create(:user) }
    let(:user_session) { { 'rack.session' => { user_id: user.id } } }

    context 'user is not logged in' do
      let(:user_session) { {} }

      it 'redirect to /login' do
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq 'http://example.org/login'
      end
    end

    context 'user is logged in' do
      it 'redirect to /dashboard' do
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq 'http://example.org/dashboard'
      end
    end
  end
end
