# frozen_string_literal: true

module Ruslanspivak
  module Internal
    class Node
      attr_reader :name, :children
      def initialize(name)
        @name = name.to_s
        @children = []
      end
      def add(child_node)
        children << child_node
      end
    end
    class RuleNode < Node
    end
    class TokenNode < Node
    end
    class Parser
      attr_reader :lexer, :current_token, :current_node
      def initialize(lexer)
        @lexer = lexer
        @current_token = lexer.next_token
        @root = nil
        @current_node = nil
      end
      def error
        raise "Invalid syntax"
      end
      def eat(token_type)
        if current_token.type == token_type
          current_node.add(TokenNode(current_token.value))
          @current_token = lexer.next_token
        else
          error
        end
      end
      def factor
        node = RuleNode('factor')
        current_node.add(node)

        _save = current_node
        @current_node = node

        token = current_token
        case token.type
        when Token::INTEGER
          eat(Token::INTEGER)
        when Token::LPAREN
          eat(LPAREN)
          expr
          eat(RPAREN)
        end
        @current_node = _save
      end
      def term
        node = RuleNode('term')
        current_node.add(node)
        _save = current_node
        @current_node = node

        factor

        while [Token::MUL, Token::DIV].include?(current_token.type)
          token = current_token
          case token.type
          when Token::MUL
            eat(MUL)
          when Token::DIV
            eat(DIV)
          end

          factor
        end

        @current_node = _save
      end
      def expr
        node = RuleNode('expr')

        if root.nil?
          @root = node
        else
          current_node.add(node)
        end

        _save = current_node
        @current_node = node

        term

        while [Token::PLUS, Token::MINUS].include?(current_token.type)
          token = current_token
          case token.type
          when Token::PLUS
            eat(PLUS)
          when Token::MINUS
            eat(MINUS)
          end
          term
        end
        @current_node = _save
      end
      def parse
        expr
        root
      end
    end
  end
  class ParseTreeVisualizer
    def initialize(parser) # rubocop:disable Metrics/MethodLength
      @parser = parser
      @ncount = 1
      @dot_header = [
        "digraph astgraph {\n"\
        "  node [shape=none, fontsize=12, fontname=\"Courier\", height=.1];\n"\
        "  ranksep=.3;\n"\
        "  edge [arrowsize=.5]\n"\
      ]
      @dot_body = []
      @dot_footer = ["}"]
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def bfs(node)
      @ncount = 1
      queue   = []

      queue << node

      add_line(node: node) do
        "node#{@ncount} [label=\"#{node.name}\"]"
      end

      while (node = queue.pop)
        node.children.each do |child_node|
          add_line(node: child_node) do
            "node#{@ncount} [label=\"#{child_node.name}\"]"
          end

          dot_body << "  node#{node.num} -> node#{child_node.num}"

          queue << child_node
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def gendot
      tree = @parser.parse
      bfs(tree)
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
