class App < Sinatra::Base
  get '/login' do
    redirect '/' if current_user

    slim :'authentication/login'
  end

  post '/login' do
    @user = User.find_by_login(params[:name], params[:password])
    if @user.nil?
      @error = 'User or password is not valid'
      slim :'authentication/login'
    else
      session[:user_id] = @user.id
      redirect '/dashboard'
    end
  end

  get '/signup' do
    @user = User.new
    if session[:user_id].nil?
      slim :'authentication/signup'
    else
      redirect '/logout'
    end
  end

  post '/signup' do
    @user = User.new(name: params[:name], new_password: params[:password])

    if @user.save
      session[:user_id] = @user.id
      redirect '/'
    else
      slim :'authentication/signup'
    end
  end

  get '/logout' do
    session[:user_id] = nil
    flash.next[:success] = 'Bye Bye'
    redirect '/login'
  end
end
