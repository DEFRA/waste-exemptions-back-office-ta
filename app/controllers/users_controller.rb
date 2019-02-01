# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    authorize! :read, current_user
    @users = list_of_users
  end

  private

  def list_of_users
    User.all.order(email: :asc)
  end
end
