# frozen_string_literal: true

module Service
  module Entities
    class Service < BaseEntity
      attribute :title, :string
      attribute :description, :string
      attribute :icon, :string
      attribute :active, :boolean, default: true
      attribute :position, :integer, default: 0
      attribute :category_id, :integer

      validates :title, presence: true

      def active?
        active == true
      end
    end
  end
end
