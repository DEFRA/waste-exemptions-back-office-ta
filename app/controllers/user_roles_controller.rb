# frozen_string_literal: true

class UserRolesController < ApplicationController
  before_action :authorize

  def edit
    assign_user(params[:id])
  end

  def update
    assign_user(params[:id])

    if @user.change_role(params.dig(:user, :role))
      redirect_to users_url
    else
      render :edit
    end
  end

  private

  def authorize
    authorize! :change_role, current_user
  end

  def assign_user(id)
    @user = User.find(id)
    @old_role = User.find(@user.id).role
  end
end
