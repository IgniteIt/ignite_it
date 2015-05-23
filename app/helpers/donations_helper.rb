module DonationsHelper
  def with_pence(amount)
    amount.to_i * 100
  end

  def without_pence(amount)
    amount / 100
  end
end
