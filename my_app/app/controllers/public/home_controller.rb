# frozen_string_literal: true

module Public
  class HomeController < BaseController
    def index
      @portfolios = Portfolio::PortfolioRepository.new.find_published.first(3)
    end
  end
end
