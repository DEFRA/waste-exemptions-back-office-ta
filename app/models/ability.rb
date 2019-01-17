# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    permissions_for_system_user if user.role_is?(:system_user)
    permissions_for_super_agent if user.role_is?(:super_agent)
    permissions_for_admin_agent if user.role_is?(:admin_agent)
    permissions_for_data_agent if user.role_is?(:data_agent)
    permissions_for_user if user.role_is?(:user)
  end

  private

  def permissions_for_system_user; end

  def permissions_for_super_agent; end

  def permissions_for_admin_agent; end

  def permissions_for_data_agent; end

  def permissions_for_user; end
end
