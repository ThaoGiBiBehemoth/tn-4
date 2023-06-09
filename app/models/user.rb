class User < ApplicationRecord
  before_save { email.downcase! }
  validates :nickname,  presence: true, uniqueness: { case_sensitive: true }, length: {maximum: 50}
  validates :email, presence: true, uniqueness: true, length: {maximum: 250}, format: {with: URI::MailTo::EMAIL_REGEXP}  #Thành
  has_many :tasks
  has_secure_password
end
