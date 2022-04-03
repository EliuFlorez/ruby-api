require "rails_helper"

RSpec.describe HealthController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/health").to route_to("health#index")
    end
  end
end
