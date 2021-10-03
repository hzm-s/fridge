# typed: strict
require 'sorbet-runtime'
require 'work/status'
require 'work/statuses/base'
require 'work/statuses/not_accepted'
require 'work/statuses/acceptable'
require 'work/statuses/accepted'

module Work
  module Statuses
    class << self
      extend T::Sig

      sig {params(issue_type: Issue::Type, criteria: Issue::AcceptanceCriteria).returns(Status)}
      def initial(issue_type, criteria)
        return Acceptable.new(issue_type) if criteria.empty?

        NotAccepted.new(issue_type)
      end
    end
  end
end
