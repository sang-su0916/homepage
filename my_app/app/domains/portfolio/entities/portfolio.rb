# frozen_string_literal: true

module Portfolio
  module Entities
    class Portfolio
      attr_reader :id, :title, :description, :client, :image_url, :published,
                  :thumbnail_url, :medium_url, :large_url

      def initialize(id:, title:, description: nil, client: nil, image_url: nil, published: false,
                     thumbnail_url: nil, medium_url: nil, large_url: nil)
        @id = id
        @title = title
        @description = description
        @client = client
        @image_url = image_url
        @published = published
        @thumbnail_url = thumbnail_url
        @medium_url = medium_url
        @large_url = large_url
        freeze
      end

      def published?
        published == true
      end

      def publish
        with(published: true)
      end

      def unpublish
        with(published: false)
      end

      private

      def with(**changes)
        self.class.new(
          id: changes.fetch(:id, id),
          title: changes.fetch(:title, title),
          description: changes.fetch(:description, description),
          client: changes.fetch(:client, client),
          image_url: changes.fetch(:image_url, image_url),
          published: changes.fetch(:published, published),
          thumbnail_url: changes.fetch(:thumbnail_url, thumbnail_url),
          medium_url: changes.fetch(:medium_url, medium_url),
          large_url: changes.fetch(:large_url, large_url)
        )
      end
    end
  end
end
