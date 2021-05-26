# frozen_string_literal: true

module Ruslanspivak
  class Token
    INTEGER = "INTEGER"
    PLUS    = "PLUS"
    EOF     = "EOF"

    attr_reader :type, :value

    def initialize(type, value)
      @type = type
      @value = value
    end

    def to_s
      "Token(#{type}, #{value})"
    end

    def ==(other)
      type == other.type && value == other.value
    end
    alias eql? ==
  end
end
