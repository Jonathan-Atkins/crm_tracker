class Api::V1::CustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :customer_not_found

  before_action :set_customer, only: [:show, :update, :destroy, :move_stage]

  def index
    customers = Customer.order(:stage)
    render json: customers, status: :ok
  end

  def show
    render json: @customer, status: :ok
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      render json: customer, status: :created
    else
      render_validation_errors(customer)
    end
  end

  def update
    if @customer.update(update_customer_params)
      render json: @customer, status: :ok
    else
      render_validation_errors(@customer)
    end
  end

  def destroy
    @customer.destroy
    render status: :no_content
  end

  def move_stage
    @customer.move_to_stage!(stage_params[:stage])
    render json: @customer, status: :ok
  rescue ArgumentError, ActiveRecord::RecordInvalid, KeyError
    render_validation_errors(@customer)
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :company, :stage)
  end

  def update_customer_params
    params.require(:customer).permit(:name, :email, :company)
  end

  def stage_params
    params.require(:customer).permit(:stage)
  end

  def customer_not_found
    render json: { error: "Customer not found" }, status: :not_found
  end

  def render_validation_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end
end