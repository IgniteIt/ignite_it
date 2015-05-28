class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = Project.find(params[:project_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.new
  end

  def create
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to project_path(@blog.project_id)
  end

  def edit
    @project = Project.find(params[:project_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.find(params[:id])
    if @comment.user != current_user
      flash[:alert] = 'Error, you did not create this comment'
      redirect_to project_path(@project)
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    find_project(@comment)
    flash[:notice] = 'Comment has been updated'
    redirect_to project_path(@project)
  end

  def destroy
    @comment = Comment.find(params[:id])
    find_project(@comment)
    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = 'Comment deleted'
    else
      flash[:alert] = 'Error, you did not create this comment'
    end
    redirect_to project_path(@project)
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  private

  def find_project(comment)
    @project = Project.find(Blog.find(comment.blog_id).project_id)
  end
end
