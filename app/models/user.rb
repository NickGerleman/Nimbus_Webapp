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

  # Taken from Rails Tutorial
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

  # Sets the User's email address as verified and clears the token
  def verify
    update_attribute 'verified', true
    update_attribute 'email_token', nil
  end

  # Whether the user has met there connection quota
  def has_max_connections
    self.connections.count >= 5
  end

  # Generate a socket token from an id
  #
  # @param id [Fixnum] the id of the user
  def self.socket_token(id)
    Gibberish::HMAC(ENV['SOCKET_KEY'], id)
  end

  # The socket token of the User
  def socket_token
    User.socket_token(id)
  end

  # Sends a verification email to the user
  def send_verify_email
    UserMailer.delay.verify_email(id)
  end

  # Generates a new password reset token and saves it to the database
  def generate_password_reset_token
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(32, false))
  end

  # Sends a password reset email to the user
  def send_password_reset
    UserMailer.delay.reset_password(id)
  end

  # Updates the password
  #
  # @param opts [Hash] the options hash
  # @option opts [String] :password the password to change to
  # @option opts [String] :password_confirmation the confirmation of the password
  # @option opts [Boolean] :reset_password(false) whether to clear the password reset token
  def upadte_password(opts)
    opts[:email_confirmation] = email
    opts[:password_reset_token] = nil if opts[:reset_password]
    update_attributes(opts)
  end

end
