Sequel.migration do
  change do
    create_table :auctions do
      primary_key :id
      foreign_key :user_id, :users, null: false
      String :title, length: 100, null: false
      String :description, length: 500, text: true
      DateTime :updated_at
      DateTime :created_at
    end
  end
end
