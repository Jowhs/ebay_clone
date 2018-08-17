class Bid < Sequel::Model
  set_primary_key :id

  many_to_one :auction
  many_to_one :user

  def before_save
    self.updated_at = Time.now
    self.created_at ||= Time.now
    super
  end

  def validate
    super
    # binding.pry
    errors.add(:amount, 'Please introduce a valid number.') if amount <= 0
    errors.add(:amount, 'You cannot bid your own auction.') if user == auction.user
    errors.add(:amount, 'New bid must be higher than current bid.') if amount <= (auction.bids_dataset.max(:amount) || 0)
  end
end
