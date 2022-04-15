class User < ApplicationRecord
  # Secure
  has_secure_password
  
  # Relations
  has_many :crms
  has_many :prospects

  # Validate
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def as_json(options={})
    options[:only] ||= [:id, :name, :email]
    super(options)
  end

  # Verifies whether a user is confirmed or not
  def confirmed?
    # code here
  end

  # Pending confirmation
  def pending_reconfirmation?
    # code here
  end

  # Send confirmation instructions by email
  def send_confirmation_instructions
    # code here
  end

  def send_reconfirmation_instructions
    # code here
  end

  # Resend confirmation token.
  # Regenerates the token if the period is expired.
  def resend_confirmation_instructions
    # code here
  end

  # Attempt to find a user by its unlock keys. If a record is found, send new
  # unlock instructions to it. If not user is found, returns a new user
  # with an email not found error.
  # Options must contain the user's unlock keys
  def send_unlock_instructions()
    # code here
  end

  # Find a user by its unlock token and try to unlock it.
  # If no user is found, returns a new user with an error.
  # If the user is not locked, creates an error for the user
  # Options must have the unlock_token
  def unlock_access_by_token(unlock_token)
    # code here
  end
  
  # Is the unlock enabled for the given unlock strategy?
  def unlock_strategy_enabled?()
    # code here
  end

  # Is the lock enabled for the given lock strategy?
  def lock_strategy_enabled?(strategy)
    # code here
  end

  # Token Generate
  def token_save!(type)
    if type == "password"
      self.reset_password_token = token_secure
      self.reset_password_sent_at = Time.now.utc
    else
      self.confirmation_token = token_secure
      self.confirmation_sent_at = Time.now.utc
    end
    save!
  end
  
  # Token Valid
  def token_valid!(type)
    if type == "password"
      (self.reset_password_sent_at + 4.hours) > Time.now.utc
    else
      (self.confirmation_sent_at + 4.hours) > Time.now.utc
    end
  end
  
  # Token Reset
  def token_reset!(type)
    if type == "password"
      self.reset_password_token = nil
    else
      self.confirmation_token = nil
    end
    save!
  end

  def token_secure
    SecureRandom.hex(10)
  end
  
  def generate_auth_token
    unless auth_token.present?
      self.auth_token = TokenGenerationService.generate
    end
  end
end
