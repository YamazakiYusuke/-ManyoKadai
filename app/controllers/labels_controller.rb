class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  before_action :are_you_manager?, only: [:index, :new, :edit, :create, :update, :destroy]

  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def edit
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to labels_path, notice: 'ラベルを作成しました'
    else
      format.html { render :new }
      format.json { render json: @label.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: 'ラベルを編集しました'
    else
      render json: @label.errors, status: :unprocessable_entity 
    end
  end

  def destroy
    @label.destroy
    respond_to do |format|
      format.html { redirect_to labels_url, notice: 'ラベルを消去しました' }
      format.json { head :no_content }
    end
  end

  private
    def set_label
      @label = Label.find(params[:id])
    end

    def label_params
      params.require(:label).permit(:label)
    end

    def are_you_manager?
      if current_user == nil || current_user.admin == false
        redirect_to tasks_path, notice: "管理権限がありません"
      end
    end
end
