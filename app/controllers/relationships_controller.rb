class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @followed_users = current_user.followed_users
  end
end
