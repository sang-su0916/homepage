# frozen_string_literal: true

module Company
  module Entities
    class Company < BaseEntity
      attribute :name, :string
      attribute :description, :string
      attribute :logo_url, :string
      attribute :founded_year, :integer
      attribute :address, :string
      attribute :phone, :string
      attribute :email, :string

      validates :name, presence: true
    end
  end
end
