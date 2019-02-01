# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = list_of_users
  end

  private

  def list_of_users
    User.all.order(email: :asc)
  end
end
