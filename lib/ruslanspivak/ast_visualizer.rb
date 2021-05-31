# frozen_string_literal: true

module Ruslanspivak
  class AstVisualizer < NodeVisitor
    def initialize(parser) # rubocop:disable Metrics/MethodLength
      @parser = parser
      @ncount = 1
      @dot_header = [
        "digraph astgraph {\n"\
        "  node [shape=circle, fontsize=12, fontname=\"Courier\", height=.1];\n"\
        "  ranksep=.3;\n"\
        "  edge [arrowsize=.5]\n"\
      ]
      @dot_body = []
      @dot_footer = ["}"]

      super()
    end

    def visit_num(node)
      add_line(node: node) { "node#{@ncount} [label=\"#{node.value}\"]" }
    end

    def visit_bin_op(node)
      add_line(node: node) { "node#{@ncount} [label=\"#{node.operator.value}\"]" }

      visit(node.left)
      visit(node.right)

      [node.left, node.right].each do |child_node|
        add_line(node: node, go_forward: false) { "node#{node.num} -> node#{child_node.num}" }
      end
    end

    def visit_unary_op(node)
      add_line(node: node) { "node#{@ncount} [label=\"unary #{node.operator.value}\"]" }

      visit(node.expr)
      add_line(node: node, go_forward: false) { "node#{node.num} -> node#{node.expr.num}" }
    end

    def gendot
      tree = @parser.parse
      visit(tree)
      (@dot_header + @dot_body + @dot_footer).join("\n")
    end

    private

    def add_line(node:, go_forward: true)
      @dot_body << "  #{yield}"
      return unless go_forward

      node.num = @ncount
      @ncount += 1
    end
  end
end
