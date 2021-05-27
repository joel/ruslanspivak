# frozen_string_literal: true

module Ruslanspivak
  class Interpreter
    def initialize(text)
      @text = text
      @position = 0
      @current_token = nil
      @current_char = text[position]
    end

    # Lexer
    # lexical analyzer, or lexer
    # rubocop:disable Metrics/MethodLength
    def next_token
      while not_ended?
        skip_whitespace if whitespace?

        break if ended?

        return Token.new(Token::INTEGER, integer) if digit?

        if current_char == "+"
          advance
          return Token.new(Token::PLUS, "+")
        end

        if current_char == "-"
          advance
          return Token.new(Token::MINUS, "-")
        end

        error
      end

      Token.new(Token::EOF, nil)
    end

    # rubocop:enable Metrics/MethodLength
    def eat(token_type)
      if current_token.type == token_type
        @current_token = next_token
      else
        error
      end
    end

    # Parser
    # parsing and interpreting
    # syntax analysis
    # syntax analyzer.
    def eval_expression # rubocop:disable Metrics/MethodLength
      @current_token = next_token

      result = term

      while [Token::PLUS, Token::MINUS].include?(current_token.type)
        token = current_token
        case token.type
        when Token::PLUS
          eat(Token::PLUS)
          result += term
        when Token::MINUS
          eat(Token::MINUS)
          result -= term
        end
      end

      result
    end

    private

    # """Return an INTEGER token value."""
    def term
      token = current_token
      eat(Token::INTEGER)
      token.value
    end

    def ended?
      current_char == Token.new(Token::EOF, nil)
    end

    def not_ended?
      !ended?
    end

    def integer
      result = ""
      while not_ended? && digit?
        result += current_char
        advance
      end
      Integer(result)
    end

    def digit?
      current_char.match?(/(?<digit>[0-9]{1})/)
    end

    def whitespace?
      current_char.match?(/(?<whitespace>\s{1})/)
    end

    def skip_whitespace
      advance while not_ended? && whitespace?
    end

    def advance
      @position += 1

      @current_char = if position > text.length - 1
                        Token.new(Token::EOF, nil)
                      else
                        text[position]
                      end

      nil
    end

    def error
      raise "Parsing error"
    end

    attr_reader :text, :position, :current_token, :current_char
  end
end
