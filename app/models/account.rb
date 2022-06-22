class Account < ApplicationRecord
  # Relations
  has_many :user

  # Validate
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
