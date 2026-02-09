require 'rails_helper'

RSpec.describe User, type: :model do
  # subject { User.create!(email: "delete@gmail.com", password: "Del@12") }
  subject { create(:user) }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should allow_value("user@gmail.com", "test.user@yahoo.com", "demo123@outlook.in", "user@com").for(:email) }
  it { should_not allow_value("usergmail.com", "user@.com", "user@ gmail.com").for(:email) }

  it { should validate_presence_of :password }
  it { should have_secure_password }
  it { should allow_value("Abc@12", "Test@34", "Xyz@567").for(:password) }
  it { should_not allow_value("abc123", "ABC@123", "Abcdef@", "Abc 12@", "A@1a", "Abcd@1234").for(:password) }

  it { should have_many(:tasks).dependent(:destroy) }

  it { should callback(:normalize_email).before(:validation) }
  it { should callback(:normalize_password).before(:validation) }
end
