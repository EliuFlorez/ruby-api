class Property < ApplicationRecord
  # Relations
  belongs_to :prospect

  # Validate
  validates :prospect, presence: true
  validates :field_name, presence: true
end
