require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "validate presence of required fields" do
      should validate_presence_of(:name)
      should validate_presence_of(:email)
      should validate_presence_of(:password)
    end

    it "validate relations" do
      should have_many(:crms)
      should have_many(:prospects)
    end
  end
end
