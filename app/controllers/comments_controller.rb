class CommentsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @blog = Blog.find(params[:blog_id])
    @comment = Comment.new
  end

  def create
    @blog = Blog.find(params[:blog_id])
    @blog.comments.create(comment_params)
    redirect_to project_path(@blog.project_id)
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
