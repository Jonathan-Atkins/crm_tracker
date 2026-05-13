class CustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :customer_not_found

  def index
    customers = Customer.all
    render json: customers, status: :ok
  end

  def show
    customer = Customer.find(params[:id])
    render json: customer, status: :ok
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer, status: :created
    else
      render_validation_errors(customer)
    end
  end

  def move_stage
    customer = Customer.find(params[:id])
    old_stage = customer.stage
    new_stage = params.require(:customer).permit(:stage)[:stage]

    if customer.update(stage: new_stage)
      StageLog.create!(
        customer: customer,
        from_stage: Customer.stages[old_stage],
        to_stage: Customer.stages[new_stage]
      )

      render json: customer, status: :ok
    else
      render_validation_errors(customer)
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :company, :stage)
  end

  def customer_not_found
    render json: { error: "Customer not found" }, status: :not_found
  end

  def render_validation_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end