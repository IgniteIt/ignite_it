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
    @user = User.find(@project.user_id)
    @video = Conred::Video.new(
      video_url: @project.video_url,
      width: 285,
      height: 185,
      error_message: "Video url is invalid"
    )
    @donation_sum = @project.donations.sum(:amount)
  end

  def edit
    @project = Project.find(params[:id])
    if @project.user_id != current_user.id
      flash[:notice] = 'Error, you did not create this project'
      redirect_to '/'
    end
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    @project.donations.each do |donation|
      person = User.find(donation.user_id)
        flash[:notice] = 'Project has been updated'
        RestClient.post "https://api:#{ENV['MAILGUN_KEY']}"\
             "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
             :from => "#{@project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
             :to => "#{person.email}",
             :subject => "#{@project.name} was edited",
             :text => "Dear #{person.username}, \n A project you supported has been edited, click here to see the edit: http://localhost:3000/projects/#{@project.id}\n."
    end
    # ProjectMailer.updated(@project)
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
