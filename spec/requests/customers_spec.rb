require "rails_helper"

RSpec.describe "Customers API", type: :request do
  describe "POST /customers" do
    it "creates a customer with valid params" do
      customer_params = {
        customer: {
          name: "Jonathan Atkins",
          email: "jonathanatkins.dev@gmail.com",
          company: "Atkins Enterprises",
          stage: "lead"
        }
      }

      post "/customers", params: customer_params, as: :json

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Jonathan Atkins")
      expect(json["email"]).to eq("jonathanatkins.dev@gmail.com")
      expect(json["company"]).to eq("Atkins Enterprises")
      expect(json["stage"]).to eq("lead")
    end
  end
end