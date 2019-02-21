# frozen_string_literal: true

class UserRolesController < ApplicationController
  before_action :authorize

  def edit
    assign_user(params[:id])
  end

  def update
    assign_user(params[:id])
    @user.change_role!(params[:user][:role])

    redirect_to users_url
  end

  private

  def authorize
    authorize! :change_role, current_user
  end

  def assign_user(id)
    @user = User.find(id)
  end
end
