# frozen_string_literal: true

module Public
  class ListPortfolios < BaseUseCase
    def initialize(repository:)
      @repository = repository
    end

    def call
      portfolios = @repository.find_published
      success(portfolios)
    end
  end
end
