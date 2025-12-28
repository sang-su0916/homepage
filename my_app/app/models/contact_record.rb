# frozen_string_literal: true

class ContactRecord < ApplicationRecord
  self.table_name = "contacts"

  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending read replied] }

  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }
end
