class Crm < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :prospect

  # Validate
  validates :user, presence: true
  validates :entity, presence: true

  def as_json(options={})
    options[:except] ||= [:oauth]
    super(options)
  end
end
