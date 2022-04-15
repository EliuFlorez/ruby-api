require 'rails_helper'

RSpec.describe Crm, type: :model do
  describe "validations" do
    it "validate presence of required fields" do
      should validate_presence_of(:user)
      should validate_presence_of(:entity)
    end

    it "validate relations" do
      should belong_to(:user)
      should have_many(:prospects)
    end
  end
end
