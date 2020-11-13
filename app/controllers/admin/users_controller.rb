class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :are_you_manager?, only: [:index, :new, :edit]

  def index
    @users = User.all.includes(:tasks).page(params[:page]).per(20).order(admin: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save 
    redirect_to admin_users_path, notice: "管理者権限でアカウントを作成しました"
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to admin_users_path, notice: "管理者権限でアカウントを更新しました"
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: '管理者権限でブログを削除しました' 
    else
      redirect_to admin_users_path, notice: '管理者をすべて消すことはできません' 
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,:admin )
  end

  def are_you_manager?
    if current_user == nil || current_user.admin == false
      redirect_to tasks_path, notice: "管理権限がありません"
    end
  end

end

