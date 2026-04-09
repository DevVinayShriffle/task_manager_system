require 'rails_helper'

RSpec.describe SendEmailsJob, type: :job do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:user) {create(:user)}
  describe "Send email job" do
    it "calls UserMailer to send a welcome email" do
      #Mock the mailer response
      mailer_double = double('mailer', deliver: true)

      #expect user mailer to recieve welcome_email with the user
      expect(UserMailer).to receive(:welcome_email).with(user).and_return(mailer_double)

      # #execute the job
      result = described_class.new.perform(user)
      expect(result).to be true
    end

    it 'actually increases the delivery count' do
      expect {
        described_class.new.perform(user)
      }.to change {ActionMailer::Base.deliveries.count}.by(1)
    end


    it "doesn't send email" do
      mailer_double = double('mailer', deliver: false)

      expect(UserMailer).to receive(:welcome_email).with(user).and_return(mailer_double)
      result = described_class.new.perform(user)
      expect(result).to be false
    end
  end
end
