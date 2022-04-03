class Search < ApplicationRecord
  # Relations
  belongs_to :user

  # Validate
  validates :user, presence: true
  validates :entity, presence: true
end
