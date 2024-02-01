# Task
class Task < ApplicationRecord
  enum status: { to_do: 0, in_progress: 1, completed: 2 }

  belongs_to :project

  validates :name, :description, :status, presence: true

  scope :by_status, ->(status) { where(status:) }
end
