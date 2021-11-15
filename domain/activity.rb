# typed: strict
require 'sorbet-runtime'

module Activity
  class PermissionDenied < StandardError; end

  autoload :Activity, 'activity/activity'
  autoload :Set, 'activity/set'
  autoload :SetProvider, 'activity/set_provider'

  class << self
    extend T::Sig

    sig {params(activity_name: Symbol, set_providers: T::Array[SetProvider]).void}
    def check_permission!(activity_name, set_providers)
      raise PermissionDenied unless allow?(activity_name, set_providers)
    end

    sig {params(activity_name: Symbol, set_providers: T::Array[SetProvider]).returns(T::Boolean)}
    def allow?(activity_name, set_providers)
      Activity.from_symbol(activity_name).allow?(set_providers)
    end
  end
end
