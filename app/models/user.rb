class User < ApplicationRecord
  has_secure_password

  validates :email, presence:true, uniqueness:true, on: :create
  # validate :email_format, on: :create
  validates :password, presence:true, on: [:create, :update]
  # validate :password_format, on: [:create, :update]

  has_many :tasks

  before_validation :normalize_email, :normalize_password
  # after_validation has_secure_password

  private

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end

  def normalize_password
    self.password = password.strip if password.present?
  end

  # def email_format
  #   if (!self.email.match(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/))
  #     errors.add("is not a valid email.")
  #   end
  # end

  # def password_format
  #   if (!self.password.match(/[A-Z](?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{5,7}$/))
  #     errors.add("is not a valid password.")
  #   end
  # end
end
# , format: {with: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/, message: "is not a valid email."}, on: [:create]
# , format: {with: /[A-Z](?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{5,7}$/, message: "is not a valid password."}, on: [:create, :update]