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
        "\n"
      ]
      @dot_body = []
      @dot_footer = ["}"]

      super()
    end

    def visit_num(node)
      s = "  node#{@ncount} [label=\"#{node.token.value}\"]\n"
      @dot_body << s
      node.num = @ncount
      @ncount += 1
    end

    def visit_bin_op(node)
      s = "  node#{@ncount} [label=\"#{node.operator.value}\"]\n"
      @dot_body << s
      node.num = @ncount
      @ncount += 1

      visit(node.left)
      visit(node.right)

      [node.left, node.right].each do |child_node|
        # puts("[#{node}][#{node.num}] => [#{child_node}][#{child_node.num}]")
        s = "  node#{node.num} -> node#{child_node.num}\n"
        @dot_body << s
      end
    end

    def visit_unary_op(node)
      s = "  node#{@ncount} [label=\"unary #{node.operator.value}\"]\n"
      @dot_body << s
      node.num = @ncount
      @ncount += 1

      visit(node.expr)
      s = "  node#{node.num} -> node#{node.expr.num}\n"
      @dot_body << s
    end

    def gendot
      tree = @parser.parse
      visit(tree)
      (@dot_header + @dot_body + @dot_footer).join
    end
  end
end
