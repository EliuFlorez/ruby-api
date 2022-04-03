require "rails_helper"

RSpec.describe CrmsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/crms").to route_to("crms#index")
    end

    it "routes to #show" do
      expect(get: "/crms/1").to route_to("crms#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/crms").to route_to("crms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/crms/1").to route_to("crms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/crms/1").to route_to("crms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/crms/1").to route_to("crms#destroy", id: "1")
    end
  end
end
