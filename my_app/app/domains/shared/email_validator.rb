# frozen_string_literal: true

module Shared
  module EmailValidator
    EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/

    def self.valid?(email)
      EMAIL_REGEX.match?(email.to_s)
    end

    def self.blank?(email)
      email.nil? || email.to_s.strip.empty?
    end
  end
end
