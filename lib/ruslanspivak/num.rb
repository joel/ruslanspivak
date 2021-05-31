# frozen_string_literal: true

module Ruslanspivak
  class Num
    attr_reader :token, :value

    def initialize(token)
      @token = token
      @value = token.value
    end

    def to_s
      "Num(#{token})"
    end

    def ==(other)
      token.type == other.token.type && value == other.value
    end
    alias eql? ==
  end
end
