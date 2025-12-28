# frozen_string_literal: true

class AdminRecord < ApplicationRecord
  self.table_name = "admins"

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
