class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @followed_users = current_user.followed_users
  end

  def create
    followed_user = User.find(params[:followed_id])
    Relationship.create(followed: followed_user, follower: current_user) if current_user.can_follow?(followed_user)
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end
