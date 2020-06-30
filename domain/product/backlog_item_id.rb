require 'securerandom'

module Product
  class BacklogItemId < Struct.new(:id)
    class << self
      def generate
        new(SecureRandom.uuid)
      end

      def from_repository(id)
        new(id)
      end
      alias_method :from_string, :from_repository
    end

    private_class_method :new

    def to_s
      id
    end
  end
end
