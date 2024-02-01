# Task
class Task < ApplicationRecord
  enum status: { to_do: 0, in_progress: 1, completed: 2 }

  belongs_to :project

  validates :name, :description, :status, :project_id, presence: true
end
