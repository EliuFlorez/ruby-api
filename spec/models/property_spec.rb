require 'rails_helper'

RSpec.describe Property, type: :model do
  describe "validations" do
    it "validate presence of required fields" do
      should validate_presence_of(:prospect)
      should validate_presence_of(:field_name)
    end

    it "validate relations" do
      should belong_to(:prospect)
    end
  end
end
