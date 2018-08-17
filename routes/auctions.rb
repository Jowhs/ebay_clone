class App < Sinatra::Base
  get '/auctions/new' do
    if current_user
      @auction = Auction.new
      slim :'auctions/create'
    else
      flash.next[:danger] = 'Please login first.'
      redirect '/login'
    end
  end

  post '/auctions' do
    @auction = Auction.new(user: current_user, title: params[:auction][:title],
                           description: params[:auction][:description])

    if @auction.save
      flash.next[:success] = "Your auction #{@auction.title} has been created."
      redirect '/auctions/new'
    else
      flash.now[:danger] = "Auction #{@auction.title} cannot be saved. Please check your data and submit again."
      slim :'auctions/create'
    end
  end

  get '/auctions/:id' do
    @auction = Auction.first(id: params[:id])
    @bid = Bid.new
    @bids = Bid.order(Sequel.desc(:created_at)).where(auction: @auction).limit(10)
    @max_bid = Bid.where(auction: @auction).max(:amount).to_i
    slim :'auctions/display'
  end

  get '/auctions/:id/edit' do
    @auction = Auction.first(id: params[:id])
    if current_user.id == @auction.user_id
      slim :'auctions/edit'
    else
      'You are not allowed to see this auction.'
    end
  end

  put '/auctions/:id' do
    # binding.pry
    @auction = Auction.first(id: params[:id])
    old_title = @auction.title
    @auction.set(title: params[:auction][:title], description: params[:auction][:description])
    if @auction.id == @auction.user.id
      redirect "/auctions/#{@auction.id}"
      return status 403
    elsif @auction.save
      flash.now[:success] = "Your auction #{@auction.title} has been updated."
    else
      flash.now[:danger] = "Auction #{old_title} cannot be saved. Please check your data and submit again."
    end
    slim :'auctions/edit'
  end

  get '/auctions' do
    @auctions = Auction.order(Sequel.desc(:created_at))
    slim :'auctions/list'
  end
end
