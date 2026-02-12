class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.secret_email
  layout "mailer"
end
