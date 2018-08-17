require 'spec_helper.rb'

describe 'Authentication' do
  describe 'GET /signup' do
    it 'responds 200' do
      get '/signup'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /signup' do
    context 'user does not exist' do
      it 'it redirects to root if user created successfully' do
        post '/signup', { name: 'santi', password: 'pass' }
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq 'http://example.org/'
        expect(User.first.name).to eq 'santi'
      end
    end

    context 'user does exist' do
      let(:user) { create(:user) }

      it 'it shows form again' do
        post '/signup', { name: user.name, password: user.password }
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('already taken')
        expect(last_response.body).to include(user.name)
      end
    end
  end

  describe 'GET /login' do
    it 'responds 200' do
      get '/login'
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /login' do
    context 'user does not exist' do
      it 'shows the form again' do
        post '/login', { name: 'blabla', password: 'pass' }
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('User or password is not valid')
      end
    end

    context 'user does exist' do
      let(:user) { create(:user) }

      it 'it redirects to root if user logged in' do
        post '/login', { name: user.name, password: 'pass' }
        expect(last_response.status).to eq 302
        expect(last_response.location).to eq 'http://example.org/dashboard'
      end
    end
  end
end
