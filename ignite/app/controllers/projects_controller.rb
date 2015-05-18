class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(project_params)
    redirect_to project_path(@project)
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def show
    @project = Project.find(params[:id])
  end
end
