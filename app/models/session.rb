class Session < ActiveRecord::Base
  attr_accessible :expiration, :token
  belongs_to :user
end
