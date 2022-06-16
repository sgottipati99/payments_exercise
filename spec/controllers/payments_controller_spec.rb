require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#index' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    it 'responds with a 200' do
      get :index, params: {loan_id: loan.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    let(:payment) { Payment.create!(amount: 10.0, payment_date: Date.today, loan_id: loan.id) }

    it 'responds with a 200' do
      get :show, params: { loan_id: loan.id, id: payment.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the payment is not found' do
      it 'responds with a 404' do
        get :show, params: { loan_id: loan.id, id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 201' do
      post :create, params: { loan_id: loan.id, payment: {amount: 10, payment_date: Date.today }}
      expect(response).to have_http_status(:created)
    end

    context 'if the payment is invalid' do
      it 'responds with a 422' do
        post :create, params: { loan_id: loan.id, payment: {amount: -10, payment_date: Date.today }}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'if the payment exceed outstanding balance of loan amount' do
      it 'responds with a 422' do
        post :create, params: { loan_id: loan.id, payment: {amount: 1000, payment_date: Date.today }}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

end
