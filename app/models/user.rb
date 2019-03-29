# frozen_string_literal: true

class User < ActiveRecord::Base
  has_paper_trail

  ROLES = %w[system
             super_agent
             admin_agent
             data_agent].freeze

  def role_is?(target_role)
    role == target_role.to_s
  end

  def active?
    active == true
  end

  def activate!
    update!(active: true)
  end

  def deactivate!
    update!(active: false)
  end

  def change_role(new_role)
    update(role: new_role)
  end

  def ability
    @ability ||= Ability.new(self)
  end

  delegate :can?, :cannot?, to: :ability

  devise :database_authenticatable,
         :invitable,
         :lockable,
         :recoverable,
         :validatable

  # Devise security improvements, used to invalidate old sessions on logout
  # Taken from https://makandracards.com/makandra/53562-devise-invalidating-all-sessions-for-a-user
  def authenticatable_salt
    "#{super}#{session_token}"
  end

  def invalidate_all_sessions!
    self.session_token = SecureRandom.hex
  end

  # Validations
  validates :role, inclusion: { in: ROLES }
  validate :password_must_have_lowercase_uppercase_and_numeric

  private

  def password_must_have_lowercase_uppercase_and_numeric
    return unless password.present? && errors[:password].empty?

    has_lowercase = (password =~ /[a-z]/)
    has_uppercase = (password =~ /[A-Z]/)
    has_numeric = (password =~ /[0-9]/)

    return true if has_lowercase && has_uppercase && has_numeric

    errors.add(:password, :invalid_format)
  end
end
