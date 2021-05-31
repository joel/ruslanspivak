# frozen_string_literal: true

module Ruslanspivak
  class NodeVisitor
    def initialize; end

    def visit(node)
      method_name = "visit_#{node.type}"
      generic_visit(node) unless respond_to?(method_name)
      public_send(method_name, node)
    end

    def generic_visit(node)
      raise StandardError, "No visit_{} method visit_#{node.type}"
    end
  end
end
