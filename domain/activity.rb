# typed: strict
require 'sorbet-runtime'

module Activity
  autoload :Activity, 'activity/activity'
  autoload :Set, 'activity/set'
  autoload :SetProvider, 'activity/set_provider'

  class << self
    extend T::Sig

    sig {params(activity: Symbol, set_providers: T::Array[SetProvider]).returns(T::Boolean)}
    def allow?(activity, set_providers)
      Activity.from_symbol(activity).allow?(set_providers)
    end
  end
end
