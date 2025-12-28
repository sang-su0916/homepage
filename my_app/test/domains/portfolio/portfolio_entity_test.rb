# frozen_string_literal: true

require "test_helper"

module Portfolio
  class PortfolioEntityTest < ActiveSupport::TestCase
    test "포트폴리오를 생성할 수 있다" do
      portfolio = Entities::Portfolio.new(
        id: 1,
        title: "A사 디지털 전환 프로젝트",
        description: "레거시 시스템을 클라우드로 마이그레이션",
        client: "A기업",
        image_url: "/images/portfolio/project-a.jpg",
        published: true
      )

      assert_equal "A사 디지털 전환 프로젝트", portfolio.title
      assert_equal "A기업", portfolio.client
      assert portfolio.published?
    end

    test "포트폴리오는 공개/비공개 상태를 가진다" do
      published = Entities::Portfolio.new(id: 1, title: "공개", published: true)
      draft = Entities::Portfolio.new(id: 2, title: "비공개", published: false)

      assert published.published?
      assert_not draft.published?
    end

    test "고객 후기를 생성할 수 있다" do
      testimonial = Entities::Testimonial.new(
        id: 1,
        portfolio_id: 1,
        author: "김대표",
        company: "A기업",
        content: "훌륭한 컨설팅 서비스였습니다.",
        rating: 5
      )

      assert_equal "김대표", testimonial.author
      assert_equal 5, testimonial.rating
    end

    test "고객 후기 평점은 1~5 사이여야 한다" do
      valid_testimonial = Entities::Testimonial.new(
        id: 1,
        author: "테스트",
        content: "좋아요",
        rating: 5
      )

      invalid_testimonial = Entities::Testimonial.new(
        id: 2,
        author: "테스트",
        content: "좋아요",
        rating: 6
      )

      assert valid_testimonial.valid?
      assert_not invalid_testimonial.valid?
    end
  end
end
