# frozen_string_literal: true

module Ruslanspivak
  class Num < Node
    attr_reader :token, :value

    def initialize(token)
      @token = token
      @value = token.value

      super()
    end

    def to_s
      "Num(#{token})"
    end

    def type
      "num"
    end

    def ==(other)
      token.type == other.token.type && value == other.value
    end
    alias eql? ==
  end
end
