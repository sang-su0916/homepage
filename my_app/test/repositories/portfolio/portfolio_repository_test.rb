# frozen_string_literal: true

require "test_helper"

module Portfolio
  class PortfolioRepositoryTest < ActiveSupport::TestCase
    setup do
      @repository = PortfolioRepository.new
    end

    test "포트폴리오를 저장하고 조회할 수 있다" do
      entity = Entities::Portfolio.new(
        id: nil,
        title: "A사 디지털 전환",
        description: "레거시 시스템 클라우드 마이그레이션",
        client: "A기업",
        image_url: "/images/portfolio/a.jpg",
        published: true
      )

      saved = @repository.save(entity)

      assert_not_nil saved.id
      assert_equal "A사 디지털 전환", saved.title
      assert saved.published?

      found = @repository.find_by_id(saved.id)
      assert_equal saved.id, found.id
    end

    test "공개된 포트폴리오만 조회할 수 있다" do
      @repository.save(Entities::Portfolio.new(id: nil, title: "공개1", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "비공개", published: false))
      @repository.save(Entities::Portfolio.new(id: nil, title: "공개2", published: true))

      published = @repository.find_published
      assert_equal 2, published.size
      assert published.all?(&:published?)
    end

    test "포트폴리오를 삭제할 수 있다" do
      saved = @repository.save(
        Entities::Portfolio.new(id: nil, title: "삭제테스트", published: false)
      )

      @repository.delete(saved.id)
      assert_nil @repository.find_by_id(saved.id)
    end

    test "고객 후기를 저장하고 조회할 수 있다" do
      portfolio = @repository.save(
        Entities::Portfolio.new(id: nil, title: "테스트 프로젝트", published: true)
      )

      testimonial = Entities::Testimonial.new(
        id: nil,
        portfolio_id: portfolio.id,
        author: "김대표",
        company: "B기업",
        content: "훌륭한 서비스였습니다.",
        rating: 5
      )

      saved = @repository.save_testimonial(testimonial)

      assert_not_nil saved.id
      assert_equal portfolio.id, saved.portfolio_id
      assert_equal "김대표", saved.author
    end

    test "포트폴리오별 고객 후기를 조회할 수 있다" do
      portfolio = @repository.save(
        Entities::Portfolio.new(id: nil, title: "프로젝트", published: true)
      )

      2.times do |i|
        @repository.save_testimonial(
          Entities::Testimonial.new(
            id: nil,
            portfolio_id: portfolio.id,
            author: "작성자#{i}",
            content: "후기#{i}",
            rating: 4
          )
        )
      end

      testimonials = @repository.find_testimonials_by_portfolio(portfolio.id)
      assert_equal 2, testimonials.size
    end

    test "제목으로 공개 포트폴리오를 검색할 수 있다" do
      @repository.save(Entities::Portfolio.new(id: nil, title: "디지털 전환 프로젝트", description: "설명1", client: "A사", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "클라우드 마이그레이션", description: "설명2", client: "B사", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "디지털 마케팅", description: "설명3", client: "C사", published: false))

      result = @repository.search_published(query: "디지털")
      assert_equal 1, result[:items].size
      assert_equal "디지털", result[:query]
      assert result[:items].first.title.include?("디지털")
    end

    test "설명으로 공개 포트폴리오를 검색할 수 있다" do
      @repository.save(Entities::Portfolio.new(id: nil, title: "프로젝트1", description: "클라우드 기반 시스템", client: "A사", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "프로젝트2", description: "온프레미스 시스템", client: "B사", published: true))

      result = @repository.search_published(query: "클라우드")
      assert_equal 1, result[:items].size
    end

    test "클라이언트명으로 공개 포트폴리오를 검색할 수 있다" do
      @repository.save(Entities::Portfolio.new(id: nil, title: "프로젝트1", description: "설명1", client: "삼성전자", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "프로젝트2", description: "설명2", client: "LG전자", published: true))

      result = @repository.search_published(query: "삼성")
      assert_equal 1, result[:items].size
      assert_equal "삼성전자", result[:items].first.client
    end

    test "검색어가 없으면 전체 공개 포트폴리오를 반환한다" do
      @repository.save(Entities::Portfolio.new(id: nil, title: "프로젝트1", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "프로젝트2", published: true))
      @repository.save(Entities::Portfolio.new(id: nil, title: "비공개", published: false))

      result = @repository.search_published(query: "")
      assert_equal 2, result[:items].size
    end

    test "검색 결과를 페이지네이션할 수 있다" do
      15.times do |i|
        @repository.save(Entities::Portfolio.new(id: nil, title: "테스트 프로젝트 #{i}", published: true))
      end

      result = @repository.search_published(query: "테스트", page: 1, limit: 10)
      assert_equal 10, result[:items].size
      assert_equal 15, result[:total_count]

      result2 = @repository.search_published(query: "테스트", page: 2, limit: 10)
      assert_equal 5, result2[:items].size
    end
  end
end
