require 'rails_helper'

RSpec.describe Prospect, type: :model do
  describe "validations" do
    it "validate presence of required fields" do
      should validate_presence_of(:user)
      should validate_presence_of(:crm)
      should validate_presence_of(:name)
      should validate_presence_of(:entity)
      should validate_presence_of(:uid)
    end

    it "validate relations" do
      should belong_to(:user)
      should belong_to(:crm)
    end
  end
end
