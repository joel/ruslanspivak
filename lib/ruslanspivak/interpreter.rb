# frozen_string_literal: true

module Ruslanspivak
  class Interpreter
    def initialize(text)
      @text = text
      @position = 0
      @current_token = nil
      @current_char = text[position]
    end

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
          return Token.new(Token::PLUS, "-")
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

    def eval_expression # rubocop:disable Metrics/MethodLength
      @current_token = next_token

      # we expect the current token to be a single-digit integer
      left = current_token
      eat(Token::INTEGER)

      # we expect the current token to be a '+' token
      op = current_token
      if op.type == Token::PLUS
        eat(Token::PLUS)
      else
        eat(Token::MINUS)
      end

      # we expect the current token to be a single-digit integer
      right = current_token
      eat(Token::INTEGER)
      # after the above call the self.current_token is set to
      # EOF token

      # At this point INTEGER PLUS INTEGER sequence of tokens
      # has been successfully found and the method can just
      # return the result of adding two integers, thus
      # effectively interpreting client input

      eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
        #{left.value} #{op.value} #{right.value} # 3 + 1
      RUBY
    end

    private

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
