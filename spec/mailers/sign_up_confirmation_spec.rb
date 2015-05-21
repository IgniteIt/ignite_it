require "rails_helper"

RSpec.describe SignUpConfirmation, type: :mailer do
  describe "sign_up_confirm" do
    let(:mail) { SignUpConfirmation.sign_up_confirm }

    xit "renders the headers" do
      expect(mail.subject).to eq("Sign up confirm")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    xit "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
