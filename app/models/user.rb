class User < ActiveRecord::Base
  before_save { |user| user.email = email.downcase }
  #Taken from Rails Tutorial
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessible :email, :name, :password_hash
  validates :email, presence: true, length: {maximum: 50}, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 50, minimum: 2}
  validates :password_hash, presence: true
end
