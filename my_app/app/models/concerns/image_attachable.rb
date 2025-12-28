# frozen_string_literal: true

module ImageAttachable
  extend ActiveSupport::Concern

  VARIANT_SIZES = {
    thumbnail: { resize_to_limit: [ 150, 100 ] },
    medium: { resize_to_limit: [ 400, 300 ] },
    large: { resize_to_limit: [ 800, 600 ] }
  }.freeze

  included do
    def thumbnail_url
      variant_url(:thumbnail)
    end

    def medium_url
      variant_url(:medium)
    end

    def large_url
      variant_url(:large)
    end

    private

    def variant_url(size)
      return nil unless image.attached?

      transformations = VARIANT_SIZES[size]
      return nil unless transformations

      Rails.application.routes.url_helpers.rails_representation_path(
        image.variant(transformations),
        only_path: true
      )
    end
  end
end
