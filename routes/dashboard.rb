class App < Sinatra::Base
  get '/dashboard' do
    @auctions = current_user.auctions_dataset.order(Sequel.desc(:created_at))
    slim :dashboard
  end
end
