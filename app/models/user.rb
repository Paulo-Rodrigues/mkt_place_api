class User < ApplicationRecord
  has_secure_password
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
