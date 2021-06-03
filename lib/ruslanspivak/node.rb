# frozen_string_literal: true

module Ruslanspivak
  class Node
    attr_accessor :num

    def type
      raise NotImplementedError
    end

    def name
      self.class.name
    end
  end
end
