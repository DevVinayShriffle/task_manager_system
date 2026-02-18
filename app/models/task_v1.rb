class Task < ApplicationRecord
  include ::Elasticsearch::Model
  include ::Elasticsearch::Model::Callbacks

  enum :status, {pending: 0, progress: 1, completed: 2}

  validates :title, presence:true
  validates :status, inclusion: {in: statuses.keys, status: :enum_argument_error}

  belongs_to :user

  before_validation :normalize_title, :normalize_descryption

  broadcasts_to ->(task) { "tasks" }

  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :descryption, :status],
      methods: [:user_id]
    )
  end


  private

  def normalize_title
    self.title = title.strip if title.present?
  end

  def normalize_descryption
    if (descryption)
      self.descryption = descryption.strip #if descryption.present?
    end
  end
end
