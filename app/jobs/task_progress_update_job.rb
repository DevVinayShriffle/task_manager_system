class TaskProgressUpdateJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    
    if(task && task.status == 'progress')
      task.update(status: "pending")
      TaskMailer.with(user: task.user, task: task).progress_task_update_notification_email.deliver_later
      task.broadcast_replace_to("job_status_channel")
    end
  end
end
