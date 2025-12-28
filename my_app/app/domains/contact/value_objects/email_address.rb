# frozen_string_literal: true

module Contact
  module ValueObjects
    class EmailAddress < Shared::BaseValueObject
      def valid?
        Shared::EmailValidator.valid?(value)
      end
    end
  end
end
