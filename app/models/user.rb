class User < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :dropbox_connections, dependent: :destroy
  has_many :google_connections, dependent: :destroy
  has_many :box_connections, dependent: :destroy
  has_many :skydrive_connections, dependent: :destroy

  has_secure_password

  before_validation do
    self.email = email.downcase
    self.verified = false
    self.email_token = SecureRandom.urlsafe_base64 32, false
  end

  after_create { send_verify_email }

  scope :old_unverified, -> do
    where("verified = 'false' AND created_at < ?", Time.now.ago(1.week))
  end

  #Taken from Rails Tutorial
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email,
            length: {maximum: 50},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false},
            confirmation: true

  validates :email_confirmation,
            presence: true

  validates :name,
            length: {maximum: 50, minimum: 2}

  validates :password,
            length: {minimum: 6, maximum: 50}

  validates :password_confirmation,
            presence: true

  validates :email_token,
            uniqueness: {case_sensitive: true}

  validates :password_reset_token,
            uniqueness: {case_sensitive: true, allow_nil: true}

  def verify
    update_attribute 'verified', true
    update_attribute 'email_token', nil
  end

  def has_max_connections
    self.connections.count >= 5
  end

  def self.socket_token(id)
    Gibberish::HMAC(ENV['SOCKET_KEY'], id)
  end

  def socket_token
    User.socket_token(id)
  end

  def send_verify_email
    UserMailer.delay.verify_email(id)
  end

  def generate_password_reset_token
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(32, false))
  end

  def send_password_reset
    UserMailer.delay.reset_password(id)
  end

  def update_reset_password(opts)
    update_attributes(password: opts[:password],
                      password_confirmation: opts[:password_confirmation],
                      email_confirmation: email,
                      password_reset_token: nil)
  end

end
