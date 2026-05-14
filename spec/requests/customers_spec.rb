require "rails_helper"

RSpec.describe "Customers", type: :request do
  describe "happy path" do
    describe "GET /customers" do
      it "can return all customers" do
        create_list(:customer, 3)

        get "/customers", as: :json
        expect(response.status).to eq(200)

        json = JSON.parse(response.body)

        expect(json).to be_an(Array)
        expect(json.length).to eq(3)
      end
    end

    describe "GET /customers/:id" do
      it "can returns a single customer" do
        customer = create(:customer, name: "Test Customer")

        get "/customers/#{customer.id}", as: :json

        expect(response.status).to eq(200)

        json = JSON.parse(response.body)

        expect(json["id"]).to eq(customer.id)
        expect(json["name"]).to eq("Test Customer")
      end
    end

    describe "POST /customers" do
      it "can create a valid customer" do
        customer_params = {
          customer: {
            name: "Jonathan Atkins",
            email: "jonathanatkins.dev@gmail.com",
            company: "Atkins Enterprises",
            stage: "lead"
          }
        }

        post "/customers", params: customer_params, as: :json

        expect(response.status).to eq(201)

        json = JSON.parse(response.body)

        expect(json["name"]).to eq("Jonathan Atkins")
        expect(json["email"]).to eq("jonathanatkins.dev@gmail.com")
        expect(json["company"]).to eq("Atkins Enterprises")
        expect(json["stage"]).to eq("lead")
      end
    end

    describe "PATCH /customers/:id/move_stage" do
      it "updates the customer's stage and creates a stage log" do
        customer = Customer.create!(
          name: "Sara Jones",
          email: "sara@example.com",
          company: "Acme Co",
          stage: :lead
        )

        patch "/customers/#{customer.id}/move_stage",
          params: {
            customer: {
              stage: "contacted"
            }
          },
          as: :json

        expect(response.status).to eq(200)

        customer.reload

        expect(customer.stage).to eq("contacted")
        expect(customer.stage_logs.count).to eq(1)

        stage_log = customer.stage_logs.last

        expect(stage_log.from_stage).to eq(Customer.stages["lead"])
        expect(stage_log.to_stage).to eq(Customer.stages["contacted"])
      end
    end

    describe "DELETE /customers/:id" do
      it "deletes an existing customer" do
        customer = create(:customer, name: "Test Customer")

        delete "/customers/#{customer.id}", as: :json

        expect(response.status).to eq(204)
        expect(Customer.find_by(id: customer.id)).to be_nil
      end
    end
  end

  describe "sad path" do
    describe "POST /customers" do
      it "fails when creating customer with invalid params" do
        customer_params = {
          customer: {
            name: "", 
            email: "invalid-email", 
            stage: "lead"
          }
        }

        post "/customers", params: customer_params, as: :json

        expect(response.status).to eq(422)

        json = JSON.parse(response.body)

        expect(json).to have_key("errors")
      end
    end

    describe "PATCH /customers/:id/move_stage" do
      it "fails when updating to an invalid stage" do
        customer = create(:customer, name: "Test Customer", stage: "lead")

        patch "/customers/#{customer.id}/move_stage",
          params: {
            customer: {
              stage: "invalid_stage"
            }
          },
          as: :json

        expect(response.status).to eq(422)

        json = JSON.parse(response.body)

        expect(json).to have_key("errors")
      end
    end

    describe "DELETE /customers/:id" do
      it "fails when deleting a non-existent customer" do
        delete "/customers/99999", as: :json

        expect(response.status).to eq(404)

        json = JSON.parse(response.body)

        expect(json).to have_key("error")
        expect(json["error"]).to eq("Customer not found")
      end
    end
  end
end