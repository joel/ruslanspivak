# frozen_string_literal: true

module Ruslanspivak
  class Interpreter < NodeVisitor
    def initialize(parser)
      @parser = parser

      super()
    end

    def interpret
      tree = parser.parse
      visit(tree)
    end

    def visit_bin_op(node) # rubocop:disable Metrics/AbcSize
      case node.operator.type
      when Token::PLUS
        visit(node.left) + visit(node.right)
      when Token::MINUS
        visit(node.left) - visit(node.right)
      when Token::MUL
        visit(node.left) * visit(node.right)
      when Token::DIV
        visit(node.left) / visit(node.right)
      end
    end

    def visit_num(node)
      node.value
    end

    private

    attr_reader :parser
  end
end
