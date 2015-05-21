# Preview all emails at http://localhost:3000/rails/mailers/sign_up_confirmation
class SignUpConfirmationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sign_up_confirmation/sign_up_confirm
  def sign_up_confirm
    SignUpConfirmation.sign_up_confirm
  end

end
