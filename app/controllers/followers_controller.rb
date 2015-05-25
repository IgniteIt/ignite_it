class FollowersController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    create
  end

  def create
    @follower = @project.followers.build_with_user(current_user)
    if @follower.save
      redirect_to projects_path
    else
      flash[:notice] = 'You are already following the project'
      redirect_to projects_path
    end
  end

  def destroy
    @follower = Follower.find(params[:id])
    if current_user == @follower.user
      @follower.destroy
      flash[:notice] = 'You are no longer following the project'
    else
      flash[:notice] = 'Cannot unfollow the project'
    end
    redirect_to '/projects'
  end
end