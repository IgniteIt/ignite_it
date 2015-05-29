class ProjectsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  include ProjectsHelper

  def index
    get_location
    get_coords
    set_search_variable(params[:search], params[:sector])

    @not_closed_project = Project.all.where("expiration_date >= ?", Time.now).order(expiration_date: :asc)
    # Tabs
    @projects = @not_closed_project.where(main_query, { search: "%#{@location}%" }).page params[:p_page]
    @near_me = @not_closed_project.near(@coord, 7).page params[:n_page]
    if current_user
      @donated = Project.joins(:donations).where("donations.user_id = ?",  current_user.id).order(expiration_date: :asc).uniq.page params[:d_page]
      @following = Project.joins(:followers).where("followers.user_id = ?", current_user.id).order(expiration_date: :asc).uniq.page params[:f_page]
    else
      @donated = @projects
      @following = @projects
    end
    # Search
    @search = Project.where(search_query, { search: "%#{@search}%", sector: "%#{@sector}%" }).order(expiration_date: :asc).page params[:s_page]
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
      flash[:alert] = 'Error, you did not create this project'
      redirect_to project_path
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
    if @project.is_owner?(current_user)
      @project.destroy
      flash[:notice] = 'Project has been deleted'
    else
      flash[:alert] = 'Error, you did not create this project'
    end
    redirect_to projects_path
  end

  def project_params
    params.require(:project).permit(:name, :description, :goal, :expiration_date, :sector, :address, :latitude, :longitude, :image, :video_url)
  end
end
