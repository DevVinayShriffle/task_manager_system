require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.create!(email: "delete@gmail.com", password: "Del@12") }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { should validate_presence_of :password }
  it { should have_secure_password }

  it { should have_many(:tasks).dependent(:destroy) }

  it { should callback(:normalize_email).before(:validation) }
  it { should callback(:normalize_password).before(:validation) }
end
