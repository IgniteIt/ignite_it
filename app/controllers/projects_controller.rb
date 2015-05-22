class ProjectsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.set_expiration_date(project_params[:expiration_date])
    @project.user = current_user
    if @project.save
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
    @video = Conred::Video.new(
      video_url: @project.video_url,
      width: 285,
      height: 185,
      error_message: "Video url is invalid"
    )
  end

  def edit
    @project = Project.find(params[:id])
    if @project.is_not_owner?(current_user)
      flash[:notice] = 'Error, you did not create this project'
      redirect_to '/'
    end
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    ProjectMailer.updated(@project).deliver_now
    flash[:notice] = 'Project has been updated'
    redirect_to project_path(@project)
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.user == current_user
      @project.destroy
      flash[:notice] = 'Project has been deleted'
      redirect_to '/'
    else
      flash[:notice] = 'Error, you did not create this project'
      redirect_to '/'
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :goal, :expiration_date, :sector, :address, :latitude, :longitude, :image, :video_url)
  end
end
