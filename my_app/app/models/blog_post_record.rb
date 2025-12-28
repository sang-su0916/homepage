# frozen_string_literal: true

class BlogPostRecord < ApplicationRecord
  include ImageAttachable

  self.table_name = "blog_posts"

  has_one_attached :image

  validates :title, presence: true

  scope :published, -> { where(published: true) }
  scope :recent, -> { order(published_at: :desc, created_at: :desc) }

  def attached_image_url
    return nil unless image.attached?

    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end

  def display_image_url
    attached_image_url || image_url
  end
end
