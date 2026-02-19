class TaskProgressCheckJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    
    if(task && task.status == 'progress')
      TaskMailer.with(user: task.user, task: task).progress_task_notification_email.deliver_later
    end
  end
end
