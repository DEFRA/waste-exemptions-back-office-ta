# frozen_string_literal: true

class User < ActiveRecord::Base
  ROLES = %w[system
             super_agent
             admin_agent
             data_agent
             user].freeze

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
  validates :password, presence: true, length: { in: 8..128 }
  validate :password_must_have_lowercase_uppercase_and_numeric

  private

  def password_must_have_lowercase_uppercase_and_numeric
    has_lowercase = (password =~ /[a-z]/)
    has_uppercase = (password =~ /[A-Z]/)
    has_numeric = (password =~ /[0-9]/)

    return true if has_lowercase && has_uppercase && has_numeric

    errors.add(:password, I18n.t("errors.messages.weakPassword"))
  end
end
