# frozen_string_literal: true

module Admin
  module Entities
    class Admin
      include Shared::Validatable

      attr_reader :id, :email, :password_digest

      def initialize(id:, email:, password_digest: nil)
        @id = id
        @email = email
        @password_digest = password_digest
        initialize_errors
        validate
        freeze
      end

      private

      def validate
        validate_presence(:email, email, message: "이메일은 필수입니다")
        validate_email_format
      end

      def validate_email_format
        return if Shared::EmailValidator.blank?(email)
        return if Shared::EmailValidator.valid?(email)

        add_error(:email, "이메일 형식이 올바르지 않습니다")
      end
    end
  end
end
