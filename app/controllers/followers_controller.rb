class FollowersController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    create
  end

  def create
    @follower = @project.followers.build_with_user(current_user)
    if @follower.save
      render json: {new_follower_count: @project.followers.count, new_follower_id: @follower.id, project_id: @project.id}
    else
      flash[:alert] = 'You are already following the project'
      redirect_to projects_path
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @follower = Follower.find(params[:id])
    if current_user == @follower.user
      @follower.destroy
      render json: {new_follower_count: @project.followers.count, project_id: @project.id}
    else
      flash[:alert] = 'Cannot unfollow the project'
    end
  end
end