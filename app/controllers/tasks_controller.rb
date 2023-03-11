class TasksController < ApplicationController
  before_action :authorize
  before_action :set_task, only: [:show, :update, :destroy]

  #SHOW LIST
  def index
    @tasks = @user.tasks.all
    render json: @tasks,  status: 200
  end

  # SHOW EACH TASK
  def show
    render json: { task: @task},  status: 200
  end

  #NEW
  def create
    @task = Task.new(task_params.merge(user: @user))

    if @task.save
      render json: @task, status: 200
    else
      render json: @task.errors, status: 422
    end
  end

  #update
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: 422 #:unprocessable_entity
    end
  end

  # DELETE
    def destroy
      if @task.destroy
        render json: { message: 'Delete done.'}, status: 200
      else
        render json: @task.errors, status: 422 #:unprocessable_entity
      end
    end

  private
  def set_task
    @task = @user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :descrip, :done)
  end
end
