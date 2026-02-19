class Task < ApplicationRecord
  include ::Elasticsearch::Model
  include ::Elasticsearch::Model::Callbacks

  enum :status, {pending: 0, progress: 1, completed: 2}

  validates :title, presence:true
  validates :status, inclusion: {in: statuses.keys, status: :enum_argument_error}

  belongs_to :user

  before_validation :normalize_title, :normalize_descryption

  after_create :schedule_status_check
  after_update :schedule_progress_check, :schedule_progress_status
  
  broadcasts_to ->(task) { "tasks" }

  settings index: {
    max_ngram_diff: 20,
    analysis: {

      analyzer: {
        ngram_analyzer: {
          tokenizer: "ngram_tokenizer",
          filter: ["lowercase"]
        }
      },
      tokenizer: {
        ngram_tokenizer: {
          type: "ngram",
          min_gram: 1,
          max_gram: 10,
          token_chars: ["letter", "digit"]
        }
      }
    }
  } do
    mappings dynamic: 'false' do
      indexes :title, type: 'text', analyzer: 'ngram_analyzer'
      indexes :user_id, type: 'integer'
    end
  end


  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :descryption, :status, :user_id]
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

  def schedule_status_check
    TaskStatusCheckJob.set(wait: 30.seconds).perform_later(self.id)
  end

  def schedule_progress_check
    TaskProgressCheckJob.set(wait: 45.seconds).perform_later(self.id)
  end

  def schedule_progress_status
    TaskProgressUpdateJob.set(wait: 1.minute).perform_later(self.id)
  end
end
