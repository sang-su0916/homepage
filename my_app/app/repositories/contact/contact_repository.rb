# frozen_string_literal: true

module Contact
  class ContactRepository < BaseRepository
    def find_all
      ContactRecord.recent.map { |record| to_entity(record) }
    end

    def find_by_id(id)
      record = ContactRecord.find_by(id: id)
      record ? to_entity(record) : nil
    end

    def find_by_status(status)
      ContactRecord.by_status(status).recent.map { |record| to_entity(record) }
    end

    def find_all_paginated(page:, limit: 10)
      records = ContactRecord.recent
      total_count = records.count
      offset = (page - 1) * limit
      paginated_records = records.offset(offset).limit(limit)

      {
        items: paginated_records.map { |record| to_entity(record) },
        total_count: total_count
      }
    end

    def find_by_status_paginated(status:, page:, limit: 10)
      records = ContactRecord.by_status(status).recent
      total_count = records.count
      offset = (page - 1) * limit
      paginated_records = records.offset(offset).limit(limit)

      {
        items: paginated_records.map { |record| to_entity(record) },
        total_count: total_count
      }
    end

    def save(entity)
      record = entity.id ? ContactRecord.find(entity.id) : ContactRecord.new
      record.assign_attributes(to_attributes(entity))
      record.save!
      to_entity(record)
    end

    def delete(id)
      ContactRecord.find_by(id: id)&.destroy
    end

    private

    def to_entity(record)
      Entities::Contact.new(
        id: record.id,
        name: record.name,
        email: record.email,
        phone: record.phone,
        message: record.message,
        status: record.status
      )
    end

    def to_attributes(entity)
      {
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        message: entity.message,
        status: entity.status
      }
    end
  end
end
