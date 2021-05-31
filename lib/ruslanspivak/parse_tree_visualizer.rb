# frozen_string_literal: true

module Ruslanspivak
  class ParseTreeVisualizer
    def initialize(parser) # rubocop:disable Metrics/MethodLength
      @parser = parser
      @ncount = 1
      @dot_header = [
        <<-HEADER
          digraph astgraph {
            node [shape=none, fontsize=12, fontname="Courier", height=.1];
            ranksep=.3;
            edge [arrowsize=.5]
        HEADER
      ]
      @dot_body = []
      @dot_footer = ["}"]
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def bfs(node)
      @ncount = 1
      queue = []
      queue << node
      s = "  node#{@ncount} [label='#{node.name}']\n"
      @dot_body << s
      node.num = @ncount
      @ncount += 1

      while (node = queue.pop)
        node.children.each do |child_node|
          s = '  node{} [label="{}"]\n'.format(ncount, child_node.name)
          dot_body.append(s)
          child_node._num = ncount
          @ncount += 1
          s = '  node{} -> node{}\n'.format(node.num, child_node.num)
          dot_body.append(s)
          queue.append(child_node)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def gendot
      tree = @parser.parse
      bfs(tree)
      (dot_header + dot_body + dot_footer).join
    end
  end
end
