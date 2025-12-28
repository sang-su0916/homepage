# frozen_string_literal: true

module Shared
  module Validatable
    def self.included(base)
      base.attr_reader :errors
    end

    def valid?
      errors.empty?
    end

    protected

    def initialize_errors
      @errors = Hash.new { |h, k| h[k] = [] }
    end

    def add_error(field, message)
      @errors[field] << message
    end

    def validate_presence(field, value, message: "#{field}은(는) 필수입니다")
      add_error(field, message) if value.nil? || value.to_s.strip.empty?
    end

    def validate_inclusion(field, value, in_array:, message: nil)
      return if in_array.include?(value)

      add_error(field, message || "#{field}은(는) #{in_array.join(', ')} 중 하나여야 합니다")
    end

    def validate_range(field, value, range:, message: nil)
      return if range.include?(value)

      add_error(field, message || "#{field}은(는) #{range.first}~#{range.last} 사이여야 합니다")
    end
  end
end
