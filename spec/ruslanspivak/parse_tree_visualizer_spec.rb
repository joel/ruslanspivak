# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe ParseTreeVisualizer do
    let(:lexer)  { Ruslanspivak::Lexer.new(input) }
    let(:parser) { Ruslanspivak::Parser.new(lexer) }
    let(:viz)    { Ruslanspivak::AstVisualizer.new(parser) }

    context "expression" do
      let(:input) { "14 + 2" }

      it do
        expect(viz.gendot).to eql(
          "digraph astgraph {"\
          "  node [shape=none, fontsize=12, fontname=\"Courier\", height=.1];\n"\
          "  ranksep=.3;\n"\
          "  edge [arrowsize=.5]\n"\
          "\n"\
          "  node1 [label=\"expr\"]\n"\
          "  node2 [label=\"term\"]\n"\
          "  node1 -> node2\n"\
          "  node3 [label=\"+\"]\n"\
          "  node1 -> node3\n"\
          "  node4 [label=\"term\"]\n"\
          "  node1 -> node4\n"\
          "  node5 [label=\"factor\"]\n"\
          "  node2 -> node5\n"\
          "  node6 [label=\"factor\"]\n"\
          "  node4 -> node6\n"\
          "  node7 [label=\"14\"]\n"\
          "  node5 -> node7\n"\
          "  node8 [label=\"2\"]\n"\
          "  node6 -> node8\n"\
          "}"
        )
      end
    end
  end
end
