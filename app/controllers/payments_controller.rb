class PaymentsController < ActionController::API

  before_action :set_loan

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: @loan.payments.all
  end

  def show
    render json: @loan.payments.find(params[:id])
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.loan_id = @loan.id
    if @payment.save
      render json: @payment, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_loan
    @loan = Loan.find(params[:loan_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_date)
  end
end