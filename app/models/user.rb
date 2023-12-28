class User < ApplicationRecord
  has_many :articles
  has_secure_password
  validates :username, :email, :password, presence: true
end
