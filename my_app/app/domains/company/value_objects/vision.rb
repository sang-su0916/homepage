# frozen_string_literal: true

module Company
  module ValueObjects
    class Vision < BaseValueObject
      attribute :title, :string
      attribute :description, :string

      validates :title, presence: true
    end
  end
end
