class BlogsController < ApplicationController
  before_action :authenticate_user!
  include BlogsHelper

  def new
    @project = Project.find(params[:project_id])
    if @project.is_not_owner?(current_user)
      flash[:alert] = 'You are not the project owner'
      redirect_to project_path(@project)
    else
      @blog = Blog.new
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @project.blogs.create(blog_params)
    BlogsMailer.email_re_blog(@project).deliver_now
    redirect_to project_path(@project)
  end

  def edit
    @project = Project.find(params[:project_id])
    @blog = Blog.find(params[:id])
    if @project.is_not_owner?(current_user)
      flash[:alert] = 'You are not the project owner'
      redirect_to project_path(@project)
    end
  end

  def update
    @blog = Blog.find(params[:id])
    @blog.update(blog_params)
    flash[:notice] = 'Blog has been updated'
    redirect_to project_path(@blog.project_id)    
  end

  def destroy
    @blog = Blog.find(params[:id])
    @project = Project.find(@blog.project_id)
    if @project.user == (current_user)
      @blog.destroy
      flash[:notice] = 'Blog deleted'
    else
      flash[:alert] = 'You are not the project owner'
    end
    redirect_to project_path(@blog.project_id)  
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end
