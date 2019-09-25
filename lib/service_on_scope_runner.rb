# frozen_string_literal: true

class ServiceOnScopeRunner
  def self.run(scope:, run_for:, service:)
    run_until = run_for.minutes.from_now

    scope.find_each do |address|
      break if Time.now > run_until

      service.run(address)
    end
  end
end
