class Crm < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :prospect

  # Validate
  validates :user, presence: true
  validates :entity, presence: true

  def as_json(options={})
    options[:except] ||= [:oauth, :expire_at, :created_at, :updated_at]
    super(options)
  end
end
