# frozen_string_literal: true

module Public
  class GetPortfolioDetail < BaseUseCase
    def initialize(repository:)
      @repository = repository
    end

    def call(id:)
      if blank?(id)
        return failure(id: [ "ID는 필수입니다" ])
      end

      portfolio = @repository.find_by_id(id)

      if portfolio.nil? || !portfolio.published?
        return failure(portfolio: [ "포트폴리오를 찾을 수 없습니다" ])
      end

      success(portfolio)
    end
  end
end
