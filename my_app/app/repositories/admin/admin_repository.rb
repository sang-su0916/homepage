# frozen_string_literal: true

module Admin
  class AdminRepository < BaseRepository
    def find_all
      AdminRecord.all.map { |record| to_entity(record) }
    end

    def find_by_id(id)
      record = AdminRecord.find_by(id: id)
      record ? to_entity(record) : nil
    end

    def find_by_email(email)
      record = AdminRecord.find_by(email: email)
      record ? to_entity(record) : nil
    end

    def email_exists?(email)
      AdminRecord.exists?(email: email)
    end

    def save(entity)
      record = entity.id ? AdminRecord.find(entity.id) : AdminRecord.new
      record.assign_attributes(to_attributes(entity))
      record.save!
      to_entity(record)
    end

    def delete(id)
      AdminRecord.find_by(id: id)&.destroy
    end

    private

    def to_entity(record)
      Entities::Admin.new(
        id: record.id,
        email: record.email,
        password_digest: record.password_digest
      )
    end

    def to_attributes(entity)
      {
        email: entity.email,
        password_digest: entity.password_digest
      }
    end
  end
end
