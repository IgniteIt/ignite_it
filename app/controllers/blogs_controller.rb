class BlogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = Project.find(params[:project_id])
    if @project.user != current_user
      flash[:notice] = 'You are not the project owner'
      redirect_to '/'
    else
      @blog = Blog.new
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @project.blogs.create(blog_params)
    # Refactor me
    @project.donations.each do |donation|
      person = User.find(donation.user_id)
      RestClient.post "https://api:key-5367fa0dd4de3f39b6ed08eeb818e4b7"\
         "@api.mailgun.net/v3/sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org/messages",
         :from => "#{@project.name} <mailgun@sandboxee3a8623dbd54edbb49b9ee665ebfad2.mailgun.org>",
         :to => "#{person.email}",
         :subject => "#{@project.name} has posted a blog",
         :text => "Dear #{person.username}, \n A project you supported has published a blog post, click here to see it: http://localhost:3000/projects/#{@project.id}\n."
    end
    redirect_to project_path(@project)
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end
