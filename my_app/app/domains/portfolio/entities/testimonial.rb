# frozen_string_literal: true

module Portfolio
  module Entities
    class Testimonial
      VALID_RATING_RANGE = (1..5)

      attr_reader :id, :portfolio_id, :author, :company, :content, :rating

      def initialize(id:, author:, content:, rating:, portfolio_id: nil, company: nil)
        @id = id
        @portfolio_id = portfolio_id
        @author = author
        @company = company
        @content = content
        @rating = rating
        freeze
      end

      def valid?
        VALID_RATING_RANGE.cover?(rating)
      end
    end
  end
end
