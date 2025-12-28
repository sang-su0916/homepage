# frozen_string_literal: true

class TestimonialRecord < ApplicationRecord
  self.table_name = "testimonials"

  belongs_to :portfolio, class_name: "PortfolioRecord"

  validates :author, presence: true
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end
