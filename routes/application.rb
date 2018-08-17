class App < Sinatra::Base
  before do
    action = request.path_info.split('/')[1]
    redirect '/login' if !current_user && !%w[login signup auctions].include?(action)
  end

  helpers do
    def current_user
      @current_user ||= User.first(id: session[:user_id]) if session[:user_id]
    end
  end

  get '/' do
    redirect '/dashboard'
  end
end
