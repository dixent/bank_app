class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bank_accounts, dependent: :destroy

  after_commit :create_bank_account

  def create_bank_account
    bank_accounts.create!
  end
end
