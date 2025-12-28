# frozen_string_literal: true

module Service
  module Entities
    class ServiceCategory < BaseEntity
      attribute :name, :string
      attribute :slug, :string
      attribute :description, :string

      validates :name, presence: true
      validates :slug, presence: true
    end
  end
end
