# frozen_string_literal: true

module Company
  module Entities
    class TeamMember < BaseEntity
      attribute :name, :string
      attribute :position, :string
      attribute :bio, :string
      attribute :photo_url, :string
      attribute :linkedin_url, :string
      attribute :display_order, :integer, default: 0

      validates :name, presence: true
      validates :position, presence: true
    end
  end
end
