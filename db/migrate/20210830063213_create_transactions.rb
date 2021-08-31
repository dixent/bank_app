class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.monetize :amount
      t.belongs_to :sender, null: false
      t.belongs_to :recipient, null: false
      t.timestamps
    end
  end
end
