class UsersController < ApplicationController
  def show
    @user = current_user
    authorize! :read, @user
  end
end
