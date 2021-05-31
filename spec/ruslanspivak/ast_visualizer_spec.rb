# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe AstVisualizer do
    let(:lexer)  { Ruslanspivak::Lexer.new(input) }
    let(:parser) { Ruslanspivak::Parser.new(lexer) }
    let(:viz)    { Ruslanspivak::AstVisualizer.new(parser) }

    let(:input)  { "- 3" }

    it do
      expect(viz.gendot).to eql(
        "digraph astgraph {\n"\
        "  node [shape=circle, fontsize=12, fontname=\"Courier\", height=.1];\n"\
        "  ranksep=.3;\n"\
        "  edge [arrowsize=.5]\n"\
        "\n"\
        "  node1 [label=\"unary -\"]\n"\
        "  node2 [label=\"3\"]\n"\
        "  node1 -> node2\n"\
        "}"
      )
    end
  end
end
