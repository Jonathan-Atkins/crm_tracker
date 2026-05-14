class Api::V1::CustomersController < ApplicationController
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

      def update
        customer = Customer.find(params[:id])

        if customer.update(update_customer_params)
          render json: customer, status: :ok
        else
          render_validation_errors(customer)
        end
      end

      def destroy
        begin
          customer = Customer.find(params[:id])
          customer.destroy
          render status: :no_content
        rescue ActiveRecord::RecordNotFound
          customer_not_found
        end
      end

      def move_stage
        customer = Customer.find(params[:id])
        old_stage = customer.stage
        new_stage = params.require(:customer).permit(:stage)[:stage]

        begin
          Customer.transaction do
            customer.update!(stage: new_stage)
            update_log(customer, old_stage, new_stage)
          end

          render json: customer, status: :ok
        rescue ArgumentError, ActiveRecord::RecordInvalid, KeyError
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

      def update_log(customer,from_stage,to_stage)
        StageLog.create!(
            customer: customer,
            from_stage: Customer.stages.fetch(from_stage),
            to_stage: Customer.stages.fetch(to_stage)
          )
      end

      def update_customer_params
        params.require(:customer).permit(:name, :email, :company)
      end
end

