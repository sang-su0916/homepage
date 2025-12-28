# frozen_string_literal: true

module Portfolio
  class PortfolioRepository < BaseRepository
    def find_all
      PortfolioRecord.recent.map { |record| to_entity(record) }
    end

    def find_by_id(id)
      record = PortfolioRecord.find_by(id: id)
      record ? to_entity(record) : nil
    end

    def find_published
      PortfolioRecord.published.recent.map { |record| to_entity(record) }
    end

    def find_published_paginated(page:, limit: 10)
      records = PortfolioRecord.published.recent
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
      records = PortfolioRecord.published
                               .where("title LIKE ? OR description LIKE ? OR client LIKE ?",
                                      search_term, search_term, search_term)
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
      records = PortfolioRecord.recent
      total_count = records.count
      offset = (page - 1) * limit
      paginated_records = records.offset(offset).limit(limit)

      {
        items: paginated_records.map { |record| to_entity(record) },
        total_count: total_count
      }
    end

    def save(entity, image: nil)
      record = entity.id ? PortfolioRecord.find(entity.id) : PortfolioRecord.new
      record.assign_attributes(to_portfolio_attributes(entity))
      record.image.attach(image) if image.present?
      record.save!
      to_entity(record)
    end

    def delete(id)
      PortfolioRecord.find_by(id: id)&.destroy
    end

    def save_testimonial(entity)
      record = entity.id ? TestimonialRecord.find(entity.id) : TestimonialRecord.new
      record.assign_attributes(to_testimonial_attributes(entity))
      record.save!
      to_testimonial_entity(record)
    end

    def find_testimonials_by_portfolio(portfolio_id)
      TestimonialRecord.where(portfolio_id: portfolio_id).map { |record| to_testimonial_entity(record) }
    end

    private

    def to_entity(record)
      Entities::Portfolio.new(
        id: record.id,
        title: record.title,
        description: record.description,
        client: record.client,
        image_url: record.image_url,
        published: record.published,
        thumbnail_url: record.thumbnail_url,
        medium_url: record.medium_url,
        large_url: record.large_url
      )
    end

    def to_portfolio_attributes(entity)
      {
        title: entity.title,
        description: entity.description,
        client: entity.client,
        published: entity.published
      }
    end

    def to_testimonial_entity(record)
      Entities::Testimonial.new(
        id: record.id,
        portfolio_id: record.portfolio_id,
        author: record.author,
        company: record.company,
        content: record.content,
        rating: record.rating
      )
    end

    def to_testimonial_attributes(entity)
      {
        portfolio_id: entity.portfolio_id,
        author: entity.author,
        company: entity.company,
        content: entity.content,
        rating: entity.rating
      }
    end
  end
end
