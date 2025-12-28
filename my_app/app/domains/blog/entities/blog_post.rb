# frozen_string_literal: true

module Blog
  module Entities
    class BlogPost < BaseEntity
      attr_reader :id, :title, :excerpt, :content, :author, :category,
                  :image_url, :published, :published_at, :created_at,
                  :thumbnail_url, :medium_url, :large_url

      def initialize(id:, title:, excerpt: nil, content: nil, author: nil,
                     category: nil, image_url: nil, published: false,
                     published_at: nil, created_at: nil,
                     thumbnail_url: nil, medium_url: nil, large_url: nil)
        @id = id
        @title = title
        @excerpt = excerpt
        @content = content
        @author = author
        @category = category
        @image_url = image_url
        @published = published
        @published_at = published_at
        @created_at = created_at
        @thumbnail_url = thumbnail_url
        @medium_url = medium_url
        @large_url = large_url
      end

      def published?
        published == true
      end
    end
  end
end
