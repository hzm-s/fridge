# typed: strict
require 'sorbet-runtime'

module Product
  class Product
    extend T::Sig

    sig {returns(::Product::ProductId)}
    attr_reader :id

    sig {returns(String)}
    attr_reader :name

    sig {returns(T.nilable(String))}
    attr_reader :description

    sig {params(name: String, description: T.nilable(String)).void}
    def initialize(name, description: nil)
      @id = T.let(::Product::ProductId.create, ::Product::ProductId)
      @name = name
      @description = description
    end
  end
end
