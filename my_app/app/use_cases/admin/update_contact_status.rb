# frozen_string_literal: true

module Admin
  class UpdateContactStatus < BaseUseCase
    VALID_STATUSES = %w[pending read replied].freeze

    def initialize(repository:)
      @repository = repository
    end

    def call(id:, status:)
      errors = validate(id, status)
      return failure(errors) if errors.any?

      contact = @repository.find_by_id(id)

      unless contact
        return failure(contact: [ "문의를 찾을 수 없습니다" ])
      end

      updated_contact = update_status(contact, status)
      saved_contact = @repository.save(updated_contact)
      success(saved_contact)
    end

    private

    def validate(id, status)
      errors = {}

      if blank?(id)
        errors[:id] = [ "ID는 필수입니다" ]
      end

      if blank?(status)
        errors[:status] = [ "상태는 필수입니다" ]
      elsif !VALID_STATUSES.include?(status)
        errors[:status] = [ "유효하지 않은 상태입니다" ]
      end

      errors
    end

    def update_status(contact, status)
      case status
      when "read"
        contact.mark_as_read
      when "replied"
        contact.mark_as_replied
      else
        contact
      end
    end
  end
end
