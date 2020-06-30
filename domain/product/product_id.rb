require 'securerandom'

module Product
  class ProductId < Struct.new(:id)
    class << self
      def generate
        SecureRandom.uuid
      end

      def from_string(string)
        new(string)
      end
    end

    def to_s
      id
    end
  end
end
