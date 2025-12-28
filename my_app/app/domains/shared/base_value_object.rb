# frozen_string_literal: true

module Shared
  class BaseValueObject
    attr_reader :value

    def initialize(value:)
      @value = value
      freeze
    end

    def ==(other)
      self.class == other.class && value == other.value
    end

    def eql?(other)
      self == other
    end

    def hash
      [ self.class, value ].hash
    end
  end
end
