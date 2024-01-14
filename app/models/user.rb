class User < ApplicationRecord
  before_save :downcase_email, :set_default_image

  has_many :articles
  has_secure_password

  validates :username, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  validates :password, presence: true,  length: { minimum: 6 }

  private

  def downcase_email
    email.downcase!
  end

  def set_default_image
    self.image = "https://loremflickr.com/300/300"
  end

end
