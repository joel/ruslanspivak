# frozen_string_literal: true

module Ruslanspivak
  class Lexer
    def initialize(text)
      @text = text
      @position = 0
      @current_char = text[position]
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/PerceivedComplexity
    def next_token
      while not_ended?
        skip_whitespace if whitespace?

        break if ended?

        return Token.new(Token::INTEGER, integer) if digit?

        if current_char == "*"
          advance
          return Token.new(Token::MUL, "*")
        end

        if current_char == "/"
          advance
          return Token.new(Token::DIV, "/")
        end

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
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/PerceivedComplexity

    def integer
      result = ""
      while not_ended? && digit?
        result += current_char
        advance
      end
      Integer(result)
    end

    def skip_whitespace
      advance while not_ended? && whitespace?
    end

    def advance
      @position += 1

      @current_char = if position > text.length - 1
                        Token.new(Token::EOF, nil)
                      else
                        # show_position
                        text[position]
                      end

      nil
    end

    def show_position # rubocop:disable Metrics/AbcSize
      t = { p: [], r: [] }
      text.chars.each_with_index do |char, index|
        next if char.match?(/(?<whitespace>\s{1})/)

        t[:p] << (index == position ? "[X]" : "-")
        t[:r] << (index == position ? "[#{char}]" : char.to_s)
      end

      puts t[:p].join(", ")
      puts t[:r].join(", ")
    end

    def error
      raise "Invalid character"
    end

    def ended?
      current_char == Token.new(Token::EOF, nil)
    end

    def not_ended?
      !ended?
    end

    def whitespace?
      current_char.match?(/(?<whitespace>\s{1})/)
    end

    def digit?
      current_char.match?(/(?<digit>[0-9]{1})/)
    end

    attr_reader :text, :position, :current_char
  end
end
