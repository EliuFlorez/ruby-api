class Prospect < ApplicationRecord
  # Relations
  belongs_to :user
  belongs_to :crm

  # Validate
  validates :user, presence: true
  validates :crm, presence: true
  validates :entity, presence: true
  validates :name, presence: true
  validates :uid, presence: true
end
