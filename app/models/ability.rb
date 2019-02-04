# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    assign_permissions_based_on_role(user) if user.active?
  end

  private

  def assign_permissions_based_on_role(user)
    permissions_for_system_user if user.role_is?(:system)
    permissions_for_super_agent if user.role_is?(:super_agent)
    permissions_for_admin_agent if user.role_is?(:admin_agent)
    permissions_for_data_agent if user.role_is?(:data_agent)
  end

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
    can :use_back_office, :all
    can :read, WasteExemptionsEngine::Registration
    can :export, WasteExemptionsEngine::Registration
  end
end
