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
    redirect_to project_path(@project)
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end
