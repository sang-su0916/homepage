# frozen_string_literal: true

module Shared
  class BaseEntity
    attr_reader :id

    def initialize(id:, **attributes)
      @id = id
      assign_attributes(attributes)
      after_initialize
      freeze
    end

    protected

    def assign_attributes(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def after_initialize
      # Hook for subclasses
    end
  end
end
