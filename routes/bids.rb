class App < Sinatra::Base
  post '/auctions/:id/bids' do
    @auction = Auction.first(id: params[:id])
    @max_bid = Bid.where(auction: @auction).max(:amount).to_i
    @bids = Bid.order(Sequel.desc(:created_at)).where(auction: @auction).limit(10)
    @bid = Bid.new(auction: @auction, user: current_user, amount: params[:bid][:amount].to_i * 100)
    if @bid.save
      flash.next[:success] = 'Your bid has been sended.'
      redirect "/auctions/#{@auction.id}"
    else
      flash.now[:danger] = 'Invalid bid. Please check your data and submit again.'
      slim :'auctions/display'
    end
  end
end
