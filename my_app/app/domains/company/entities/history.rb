# frozen_string_literal: true

module Company
  module Entities
    class History < BaseEntity
      attribute :year, :integer
      attribute :month, :integer
      attribute :title, :string
      attribute :description, :string

      validates :year, presence: true
      validates :title, presence: true
    end
  end
end
