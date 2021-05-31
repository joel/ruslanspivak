# frozen_string_literal: true

module Ruslanspivak
  class UnaryOp < Node
    attr_reader :operator, :token, :expr

    def initialize(operator, expr)
      @token = @operator = operator
      @expr = expr

      super()
    end

    def type
      "unary_op"
    end
  end
end
