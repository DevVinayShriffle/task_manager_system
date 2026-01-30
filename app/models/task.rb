class Task < ApplicationRecord
  enum :status, {pending: 0, progress: 1, completed: 2}

  validates :title, presence:true
  validates :status, inclusion: {in: statuses.keys, message: "is not a valid status."}

  belongs_to :user

  before_validation :normalize_title, :normalize_descryption

  private

  def normalize_title
    self.title = title.strip
  end

  def normalize_descryption
    if (descryption)
      self.descryption = descryption.strip
    end
  end
end
