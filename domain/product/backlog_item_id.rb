require 'securerandom'

module Product
  class BacklogItemId < Struct.new(:id)
    def self.generate
      new(SecureRandom.uuid)
    end

    def to_s
      id
    end
  end
end
