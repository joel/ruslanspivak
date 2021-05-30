# frozen_string_literal: true

module Ruslanspivak
  class Parser
    def initialize(lexer)
      @lexer = lexer
      @current_token = lexer.next_token
    end

    def parse
      expression
    end

    private

    # Arithmetic expression parser.

    # Grammar:
    # expr   : factor ((MUL | DIV) factor)*
    # factor : INTEGER
    def expression # rubocop:disable Metrics/MethodLength
      result = current_token.value

      factor

      while operator?
        case current_token.type
        when Token::MUL
          eat(Token::MUL)
          result *= current_token.value
          factor
        when Token::DIV
          eat(Token::DIV)
          result /= current_token.value
          factor
        end
      end

      result
    end

    def operator?
      [Token::MUL, Token::DIV].include?(current_token.type)
    end

    def error
      raise "Invalid syntax"
    end

    def eat(token_type)
      if current_token.type == token_type
        @current_token = lexer.next_token
      else
        error
      end
    end

    def factor
      eat(Token::INTEGER)
    end

    attr_reader :lexer, :current_token
  end
end
