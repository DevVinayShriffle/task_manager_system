class User < ApplicationRecord
  has_secure_password

  # validates :email, presence:true, uniqueness:true, on: :create
  # validate :email_format, on: :create
  # validates :password, presence:true, on: [:create, :update]
  # validate :password_format, on: [:create, :update]

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
              with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,8}\z/,
              message: "must include 1 uppercase, 1 lowercase, 1 special character, 1 number and has length between 6 to 8 characters."
            }
  
  has_many :tasks, dependent: :destroy

  before_validation :normalize_email, :normalize_password
  # after_validation has_secure_password

  # def password=(new_password)
  #   super(new_password.strip) if new_password.present?
  # end

  private

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end

  def normalize_password
    self.password = password.strip if password.present?
  end

  # def email_format
  #   if (!self.email.match(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/))
  #     errors.add("is not a valid email.")
  #   end
  # end

  # def password_format
  #   if (!self.password.match(/[A-Z](?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{5,7}$/))
  #   if (!self.password.match(/\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,8}\z/))
  #     errors.add("is not a valid password.")
  #   end
  # end
end
