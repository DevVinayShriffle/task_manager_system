class TaskMailer < ApplicationMailer
  def overdue_task_notification_email
    @user = params[:user]
    @task = params[:task]
    mail(to: @user.email, subject: "Your task is overdue: #{@task.title}")
  end

  def progress_task_notification_email
    @user = params[:user]
    @task = params[:task]
    mail(to: @user.email, subject: "Your task is overdue: #{@task.title}")
  end

  def progress_task_update_notification_email
    @user = params[:user]
    @task = params[:task]
    mail(to: @user.email, subject: "Your task is set to pending: #{@task.title}")
  end
end
