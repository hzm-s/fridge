# typed: ignore
module Product
  module BacklogItemStatus
    class Status < Struct.new(:kind)
      def to_s
        @_string ||= kind.to_s
      end
    end

    Preparation = Status.new(:preparation)
  end
end
