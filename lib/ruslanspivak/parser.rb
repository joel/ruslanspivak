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

    # """factor : INTEGER | LPAREN expr RPAREN"""
    def factor # rubocop:disable Metrics/MethodLength
      token = current_token
      case token.type
      when Token::PLUS
        eat(Token::PLUS)
        UnaryOp.new(token, factor)
      when Token::MINUS
        eat(Token::MINUS)
        UnaryOp.new(token, factor)
      when Token::INTEGER
        eat(Token::INTEGER)
        Num.new(token)
      when Token::LPAREN
        eat(Token::LPAREN)
        node = expression
        eat(Token::RPAREN)
        node
      end
    end

    # """term : factor ((MUL | DIV) factor)*"""
    def term # rubocop:disable Metrics/MethodLength
      node = factor

      while [Token::MUL, Token::DIV].include?(current_token.type)
        token = current_token

        case current_token.type
        when Token::MUL
          eat(Token::MUL)
        when Token::DIV
          eat(Token::DIV)
        end

        node = BinOp.new(node, token, factor)
      end

      node
    end

    # Arithmetic expression parser / interpreter.

    # calc>  14 + 2 * 3 - 6 / 2
    # 17

    # expr   : term ((PLUS | MINUS) term)*
    # term   : factor ((MUL | DIV) factor)*
    # factor : INTEGER
    def expression # rubocop:disable Metrics/MethodLength
      node = term

      while [Token::PLUS, Token::MINUS].include?(current_token.type)
        token = current_token

        case current_token.type
        when Token::PLUS
          eat(Token::PLUS)
        when Token::MINUS
          eat(Token::MINUS)
        end

        node = BinOp.new(node, token, term)
      end

      node
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
