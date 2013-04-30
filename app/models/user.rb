class User < ActiveRecord::Base
  attr_accessible :email, :email_confirmation, :name, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }

  #Taken from Rails Tutorial
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: 50}, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}, confirmation: true
  validates :name, presence: true, length: {maximum: 50, minimum: 2}
  validates :password, presence: true, length: {minimum: 6, maximum: 50}
  validates :password_confirmation, presence: true
end
