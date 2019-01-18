# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    permissions_for_system_user if user.role_is?(:system)
    permissions_for_super_agent if user.role_is?(:super_agent)
    permissions_for_admin_agent if user.role_is?(:admin_agent)
    permissions_for_data_agent if user.role_is?(:data_agent)
  end

  private

  def permissions_for_system_user
    can :invite, User
    can :read, User
    can :change_role, User
    can :enable_or_disable, User

    permissions_for_super_agent
  end

  def permissions_for_super_agent
    can :update, WasteExemptionsEngine::Registration
    can :deregister, WasteExemptionsEngine::Registration
    can :deregister, WasteExemptionsEngine::RegistrationExemption

    permissions_for_admin_agent
  end

  def permissions_for_admin_agent
    can :create, WasteExemptionsEngine::Registration
    can :create, WasteExemptionsEngine::TransientRegistration
    can :update, WasteExemptionsEngine::TransientRegistration

    permissions_for_data_agent
  end

  def permissions_for_data_agent
    can :read, WasteExemptionsEngine::Registration
    can :export, WasteExemptionsEngine::Registration
  end
end
