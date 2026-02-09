require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should define_enum_for(:status).with_values(pending: 0, progress: 1, completed: 2) }
  # it { should validate_inclusion_of(:status).in_array([:pending, :progress, :completed]) }

  it { should validate_presence_of :title }
  it { should_not validate_presence_of :descryption }

  it { should belong_to :user }

  it { should callback(:normalize_title).before(:validation) }
  it { should callback(:normalize_descryption).before(:validation) }

  it "strips title before validation" do
    task = subject
    task.title = "   Hello Task    "
    task.valid?
    expect(task.title).to eq("Hello Task")
  end
end
