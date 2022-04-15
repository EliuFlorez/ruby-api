class Crm < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :prospects

  # Validate
  validates :user, presence: true
  validates :entity, presence: true

  def as_json(options={})
    options[:only] ||= [:id, :name, :entity, :status]
    super(options)
  end
end
