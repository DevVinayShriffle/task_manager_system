class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :descryption, :status, :user_id
end
