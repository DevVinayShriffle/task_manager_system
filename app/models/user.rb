class User < ApplicationRecord
  has_secure_password

  validates :email,
  presence: true,
  uniqueness: true,
  format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "must be a valid email address"
  }
  
  validates :password,
  presence: true,
  format: {
    with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])\S{6,8}\z/,
    message: "must include 1 uppercase, 1 lowercase, 1 special character, 1 number, has length between 6 to 8 characters and does not contain any spaces."
  }
  
  has_many :tasks, dependent: :destroy

  before_validation :normalize_email, :normalize_password
  after_create :send_welcome_email

  private

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end

  def normalize_password
    self.password = password.strip if password.present?
  end

  def send_welcome_email
    SendEmailsJob.set(wait: 1.minute).perform_later(self)
  end
end
