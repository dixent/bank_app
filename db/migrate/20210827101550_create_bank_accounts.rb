class CreateBankAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_accounts do |t|
      t.monetize :balance
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
