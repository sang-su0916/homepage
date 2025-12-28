# frozen_string_literal: true

class PortfolioRecord < ApplicationRecord
  include ImageAttachable

  self.table_name = "portfolios"

  has_one_attached :image

  has_many :testimonials, class_name: "TestimonialRecord", foreign_key: "portfolio_id", dependent: :destroy

  validates :title, presence: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }

  def image_url
    return nil unless image.attached?

    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end
end
