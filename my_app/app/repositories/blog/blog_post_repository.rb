# frozen_string_literal: true

module Blog
  class BlogPostRepository < BaseRepository
    def find_all
      BlogPostRecord.recent.map { |record| to_entity(record) }
    end

    def find_by_id(id)
      record = BlogPostRecord.find_by(id: id)
      record ? to_entity(record) : nil
    end

    def find_published
      BlogPostRecord.published.recent.map { |record| to_entity(record) }
    end

    def find_published_paginated(page:, limit: 10)
      records = BlogPostRecord.published.recent
      total_count = records.count
      offset = (page - 1) * limit
      paginated_records = records.offset(offset).limit(limit)

      {
        items: paginated_records.map { |record| to_entity(record) },
        total_count: total_count
      }
    end

    def search_published(query:, page: 1, limit: 10)
      return find_published_paginated(page: page, limit: limit) if query.blank?

      search_term = "%#{query}%"
      records = BlogPostRecord.published
                              .where("title LIKE ? OR content LIKE ? OR excerpt LIKE ? OR author LIKE ? OR category LIKE ?",
                                     search_term, search_term, search_term, search_term, search_term)
                              .recent
      total_count = records.count
      offset = (page - 1) * limit
      paginated_records = records.offset(offset).limit(limit)

      {
        items: paginated_records.map { |record| to_entity(record) },
        total_count: total_count,
        query: query
      }
    end

    def find_all_paginated(page:, limit: 10)
      records = BlogPostRecord.recent
      total_count = records.count
      offset = (page - 1) * limit
      paginated_records = records.offset(offset).limit(limit)

      {
        items: paginated_records.map { |record| to_entity(record) },
        total_count: total_count
      }
    end

    def save(entity, image: nil)
      record = entity.id ? BlogPostRecord.find(entity.id) : BlogPostRecord.new
      record.assign_attributes(to_attributes(entity))
      record.image.attach(image) if image.present?

      if entity.published && record.published_at.nil?
        record.published_at = Time.current
      end

      record.save!
      to_entity(record)
    end

    def delete(id)
      BlogPostRecord.find_by(id: id)&.destroy
    end

    private

    def to_entity(record)
      Entities::BlogPost.new(
        id: record.id,
        title: record.title,
        excerpt: record.excerpt,
        content: record.content,
        author: record.author,
        category: record.category,
        image_url: record.display_image_url,
        published: record.published,
        published_at: record.published_at,
        created_at: record.created_at,
        thumbnail_url: record.thumbnail_url,
        medium_url: record.medium_url,
        large_url: record.large_url
      )
    end

    def to_attributes(entity)
      {
        title: entity.title,
        excerpt: entity.excerpt,
        content: entity.content,
        author: entity.author,
        category: entity.category,
        image_url: entity.image_url,
        published: entity.published
      }
    end
  end
end
