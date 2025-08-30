# frozen_string_literal: true

module Questionize
  extend ActiveSupport::Concern

  class_methods do
    def questionize(attr)
      define_method "questionized_#{attr}" do
        questionize(self.send(attr))
      end
    end
  end

  included do
    def questionize(label)
      first, *middle, last = label.chars

      prefix = vowel?(first) ? "Est-ce qu'" : "Est-ce que "

      [
        prefix,
        first.downcase,
        middle,
        last == "." ? "" : last,
        " ?"
      ].compact.join
    end

    private

    def vowel?(char)
      char.downcase.in?(%w[a e i o u])
    end
  end
end
