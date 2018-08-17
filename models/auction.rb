class Auction < Sequel::Model
  set_primary_key :id

  many_to_one :user
  one_to_many :bids

  def before_save
    self.updated_at = Time.now
    self.created_at ||= Time.now
    super
  end

  def validate
    super
    validates_presence %i{title description}
    validates_format(/\A[A-Za-z]/, :title, message: 'is not a valid title')
    validates_length_range 5..100, :title
    validates_length_range 20..500, :description
  end
end
