class Payment < ActiveRecord::Base
  belongs_to :loan

  validates_presence_of :amount, :payment_date
  validates :amount, :numericality => { greater_than: 0 }
  validate :check_exceed_loan_balance_amount

  def check_exceed_loan_balance_amount
    loan_balance = loan.funded_amount - loan.payments.sum(:amount)
    errors.add(:amount, "exceeds the outstanding balance of a loan") if loan_balance < amount
  end
end
