class TasksResponseSerializer < ActiveModel::Serializer
  attributes :message, :tasks

  def message
    instance_options[:message]
  end

  def tasks
    if instance_options[:tasks].length > 0
      instance_options[:tasks].map do |task|
        TaskSerializer.new(task).as_json
      end
    else
      TaskSerializer.new(tasks).as_json
    end
  end

  # def task
  #   TaskSerializer.new(task).as_json
  # end
end
