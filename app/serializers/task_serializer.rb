# Task data that could be sent
class TaskSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :status, :project_id, :created_at, :updated_at
end
