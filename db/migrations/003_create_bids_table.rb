Sequel.migration do
  change do
    create_table :bids do
      primary_key :id
      foreign_key :auction_id, :auctions, null: false
      foreign_key :user_id, :users, null: false
      Integer :amount, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
