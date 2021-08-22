# typed: strict
require 'sorbet-runtime'

module Work
  class Task
    extend T::Sig

    class << self
      extend T::Sig

      sig {params(number: Integer, content: String).returns(T.attached_class)}
      def create(number, content)
        new(number, content, TaskStatus::Todo)
      end

      sig {params(number: Integer, content: String, status: TaskStatus).returns(T.attached_class)}
      def from_repository(number, content, status)
        new(number, content, status)
      end
    end

    sig {returns(Integer)}
    attr_reader :number

    sig {returns(String)}
    attr_reader :content

    sig {returns(TaskStatus)}
    attr_reader :status

    sig {params(number: Integer, content: String, status: TaskStatus).void}
    def initialize(number, content, status)
      @number = number
      @content = content
      @status = status
    end

    sig {params(new_content: String).void}
    def modify(new_content)
      @content = new_content
    end

    sig {void}
    def start
      @status = @status.start
    end

    sig {void}
    def complete
      @status = @status.complete
    end

    sig {void}
    def suspend
      @status = @status.suspend
    end

    sig {void}
    def resume
      @status = @status.resume
    end
  end
end
