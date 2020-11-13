class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :unless_logged_in?, only: [:index, :show]

  def index
    tasks = current_user.tasks
    if params[:task]
      params_sarch_title = params[:task][:sarch_title]
      params_sarch_status = params[:task][:sarch_status] 
      if params[:task][:label_id] != ""
        set_label = Label.find(params[:task][:label_id]) 
        set_label = set_label.tasks
      end
      # タイトル&ステータス&ラベル検索
      if params_sarch_title != "" && params_sarch_status != "" && params[:task][:label_id] != ""
        @tasks = set_label.title_scope(params_sarch_title).status_scope(params_sarch_status) 
      # タイトル＆ステータス / タイトル＆ラベル / ステータス&ラベル 検索
      elsif params_sarch_title != "" && params_sarch_status != ""
        @tasks = tasks.title_scope(params_sarch_title).status_scope(params_sarch_status)
      elsif params_sarch_title != "" && params[:task][:label_id] != ""
        @tasks = set_label.title_scope(params_sarch_title)
      elsif params_sarch_status != "" && params[:task][:label_id] != ""
        @tasks = set_label.status_scope(params_sarch_status)
      # タイトル / ステータス / ラベル 検索
      elsif params_sarch_title != ""
        @tasks = tasks.title_scope(params_sarch_title)
      elsif params_sarch_status != ""
        @tasks = tasks.status_scope(params_sarch_status)
      elsif params[:task][:label_id] != ""
        @tasks = set_label
      # その他 何も入力しないで検索を押したとき
      else
        @tasks = tasks.order(limit: :desc)
      end
    else

      if params["sort_expired"]
        @tasks = tasks.order(limit: :desc)
      elsif params["sort_priority"]
        @tasks = tasks.order(priority: :desc)
      else
        @tasks = tasks.order(created_at: :desc)
      end
    end
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
    redirect_to tasks_path, notice: '指定のページは表示できません' if current_user.id != @task.user.id
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: '新しいタスクを登録しました' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @task.user_id = current_user.id   
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'タスクの内容を更新しました' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'タスクを削除しました' }
      format.json { head :no_content }
    end
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :limit, :status, :priority, label_ids: [] )
  end

  def unless_logged_in?
    unless logged_in?
      redirect_to new_session_path, notice: "ログインしてください" 
    end
  end
end
