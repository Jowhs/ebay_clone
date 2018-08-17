class User < Sequel::Model
  set_primary_key :id

  one_to_many :auctions
  one_to_many :bids

  attr_accessor :new_password

  def before_save
    self.created_at ||= Time.now
    self.password = Digest::MD5.hexdigest(new_password) if new_password
    super
  end

  def validate
    super
    validates_presence [:name]
    validates_format(/\A[A-Za-z]/, :name, message: 'is not a valid name')
    validates_length_range 3..8, :name
    validates_unique :name
    validates_min_length(3, :new_password) if new_password
    validates_presence [:password] unless new_password
  end

  def self.find_by_login(name, password)
    md5sum = Digest::MD5.hexdigest password
    User.first(name: name, password: md5sum)
  end
end
