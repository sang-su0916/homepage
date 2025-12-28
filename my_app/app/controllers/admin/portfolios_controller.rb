# frozen_string_literal: true

module Admin
  class PortfoliosController < BaseController
    before_action :set_portfolio, only: [ :show, :edit, :update, :destroy ]

    def index
      page = (params[:page] || 1).to_i
      result = portfolio_repository.find_all_paginated(page: page)

      @pagy = Pagy.new(count: result[:total_count], page: page)
      @portfolios = result[:items]
    end

    def show
    end

    def new
      @portfolio = OpenStruct.new(published: false)
    end

    def create
      use_case = ::Admin::CreatePortfolio.new(repository: portfolio_repository)
      result = use_case.call(portfolio_params)

      if result.success?
        redirect_to admin_portfolios_path, notice: "포트폴리오가 생성되었습니다."
      else
        @portfolio = OpenStruct.new(portfolio_params)
        @errors = result.errors
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      entity = Portfolio::Entities::Portfolio.new(
        id: @portfolio.id,
        title: portfolio_params[:title] || @portfolio.title,
        description: portfolio_params[:description] || @portfolio.description,
        client: portfolio_params[:client] || @portfolio.client,
        published: portfolio_params.key?(:published) ? portfolio_params[:published] : @portfolio.published
      )

      portfolio_repository.save(entity, image: portfolio_params[:image])
      redirect_to admin_portfolios_path, notice: "포트폴리오가 수정되었습니다."
    end

    def destroy
      portfolio_repository.delete(@portfolio.id)
      redirect_to admin_portfolios_path, notice: "포트폴리오가 삭제되었습니다."
    end

    private

    def set_portfolio
      @portfolio = portfolio_repository.find_by_id(params[:id].to_i)
      render file: Rails.public_path.join("404.html"), status: :not_found, layout: false unless @portfolio
    end

    def portfolio_repository
      Portfolio::PortfolioRepository.new
    end

    def portfolio_params
      params.require(:portfolio).permit(:title, :description, :client, :image, :published)
    end
  end
end
