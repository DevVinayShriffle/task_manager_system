class TaskStatusCheckJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    
    if(task && task.status == 'pending')
      TaskMailer.with(user: task.user, task: task).overdue_task_notification_email.deliver_later
    end
  end
end
