# frozen_string_literal: true

module Public
  class PortfoliosController < BaseController
    def index
      page = (params[:page] || 1).to_i
      @query = params[:q].to_s.strip

      result = if @query.present?
                 portfolio_repository.search_published(query: @query, page: page)
               else
                 portfolio_repository.find_published_paginated(page: page)
               end

      @pagy = Pagy.new(count: result[:total_count], page: page)
      @portfolios = result[:items]
    end

    def show
      use_case = ::Public::GetPortfolioDetail.new(repository: portfolio_repository)
      result = use_case.call(id: params[:id].to_i)

      if result.success?
        @portfolio = result.data
      else
        render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
      end
    end

    private

    def portfolio_repository
      Portfolio::PortfolioRepository.new
    end
  end
end
