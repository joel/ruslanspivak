# frozen_string_literal: true

module Ruslanspivak
  class BinOp < Node
    attr_reader :left, :operator, :right, :token

    def initialize(left, operator, right)
      @left = left
      @token = @operator = operator
      @right = right

      super()
    end

    def to_s
      "BinOp(#{left}, #{operator}, #{right})"
    end

    def type
      "bin_op"
    end
  end
end
