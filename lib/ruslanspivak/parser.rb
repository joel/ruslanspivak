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

    def factor
      token = current_token
      eat(Token::INTEGER)
      token.value
    end

    # """term : factor ((MUL | DIV) factor)*"""
    def term # rubocop:disable Metrics/MethodLength
      result = factor

      while [Token::MUL, Token::DIV].include?(current_token.type)
        case current_token.type
        when Token::MUL
          eat(Token::MUL)

          right = op(result, "*", factor)
          result *= right

        when Token::DIV
          eat(Token::DIV)

          right = op(result, "/", factor)
          result /= right

        end
      end

      result
    end

    # Arithmetic expression parser / interpreter.

    # calc>  14 + 2 * 3 - 6 / 2
    # 17

    # expr   : term ((PLUS | MINUS) term)*
    # term   : factor ((MUL | DIV) factor)*
    # factor : INTEGER
    def expression # rubocop:disable Metrics/MethodLength
      result = term

      while [Token::PLUS, Token::MINUS].include?(current_token.type)
        case current_token.type
        when Token::PLUS
          eat(Token::PLUS)

          right = op(result, "+", term)
          result += right

        when Token::MINUS
          eat(Token::MINUS)

          right = op(result, "-", term)
          result -= right

        end
      end
      result
    end

    def op(result, operand, next_value)
      puts(" ====> #{result} #{operand} #{next_value} ")
      next_value
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

    attr_reader :lexer, :current_token
  end
end
