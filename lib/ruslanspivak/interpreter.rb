# frozen_string_literal: true

module Ruslanspivak
  class Interpreter
    def initialize(text)
      @text = text
      @position = 0
      @current_token = nil
    end

    def error
      raise "Parsing error"
    end

    def next_token # rubocop:disable Metrics/MethodLength
      return Token.new(Token::EOF, nil) if position > text.length - 1

      current_char = text[position]

      if /[0-9]{1}/.match?(current_char)
        @position += 1
        return Token.new(Token::INTEGER, Integer(current_char))
      end

      if current_char == "+"
        @position += 1
        return Token.new(Token::PLUS, current_char)
      end

      error
    end

    def eat(token_type)
      if current_token.type == token_type
        @current_token = next_token
      else
        error
      end
    end

    def eval_expression
      @current_token = next_token

      # we expect the current token to be a single-digit integer
      left = current_token
      eat(Token::INTEGER)

      # we expect the current token to be a '+' token
      op = current_token
      eat(Token::PLUS)

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

    attr_reader :text, :position, :current_token
  end
end
