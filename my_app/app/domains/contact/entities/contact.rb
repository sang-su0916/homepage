# frozen_string_literal: true

module Contact
  module Entities
    class Contact
      VALID_STATUSES = %w[pending read replied].freeze

      attr_reader :id, :name, :email, :phone, :message, :status

      def initialize(id:, name:, email:, message:, status: "pending", phone: nil)
        @id = id
        @name = name
        @email = email
        @phone = phone
        @message = message
        @status = status
        freeze
      end

      def valid?
        VALID_STATUSES.include?(status)
      end

      def mark_as_read
        with(status: "read")
      end

      def mark_as_replied
        with(status: "replied")
      end

      private

      def with(**changes)
        self.class.new(
          id: changes.fetch(:id, id),
          name: changes.fetch(:name, name),
          email: changes.fetch(:email, email),
          phone: changes.fetch(:phone, phone),
          message: changes.fetch(:message, message),
          status: changes.fetch(:status, status)
        )
      end
    end
  end
end
