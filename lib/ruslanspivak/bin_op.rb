# frozen_string_literal: true

module Ruslanspivak
  class BinOp
    def initialize(left, operator, right)
      @left = left
      @token = @operator = operator
      @right = right
    end

    def to_s
      "BinOp(#{left}, #{operator}, #{right})"
    end

    private

    attr_reader :left, :operator, :right, :token
  end
end
