class User < ApplicationRecord
  # Secure
  has_secure_password
  
  # Relations
  has_many :crms
  has_many :prospects

  # Validate
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def as_json(options={})
    options[:only] ||= [
      :id, 
      :first_name, 
      :last_name, 
      :email, 
      :phone,
      :address,
      :address_number,
      :city,
      :provice_state,
      :portal_code,
      :country,
      :sign_in_twofa
    ]
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
    case type
    when "password"
      self.password_token = token_secure
      self.password_sent_at = Time.now.utc
    when "code"
      self.twofa_code = rand(999_999)
      self.twofa_code_token = token_secure
      self.twofa_code_at = Time.now.utc
    when "email"
      self.change_email_token = token_secure
      self.change_email_at = Time.now.utc
    when "confirmation"
      self.confirmation_token = token_secure
      self.confirmation_sent_at = Time.now.utc
    else
      raise StandardError.new "Error: type has an invalid value (#{type})"
    end
    save!
  end
  
  # Token Valid
  def token_valid!(type)
    case type
    when "password"
      (self.password_sent_at + 4.hours) > Time.now.utc
    when "code"
      (self.twofa_code_at + 4.hours) > Time.now.utc
    when "email"
      (self.change_email_at + 4.hours) > Time.now.utc
    when "confirmation"
      (self.confirmation_sent_at + 4.hours) > Time.now.utc
    else
      raise StandardError.new "Error: type has an invalid value (#{type})"
    end
  end
  
  # Token Reset
  def token_reset!(type)
    case type
    when "password"
      self.password_token = nil
    when "code"
      self.twofa_code = nil
      self.twofa_code_token = nil
    when "email"
      self.change_email_token = nil
    when "confirmation"
      self.confirmation_token = nil
    else
      raise StandardError.new "Error: type has an invalid value (#{type})"
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
