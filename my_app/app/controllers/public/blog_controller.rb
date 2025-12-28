# frozen_string_literal: true

module Public
  class BlogController < BaseController
    def index
      page = (params[:page] || 1).to_i
      @query = params[:q].to_s.strip

      result = if @query.present?
                 blog_repository.search_published(query: @query, page: page, limit: 12)
               else
                 blog_repository.find_published_paginated(page: page, limit: 12)
               end

      @pagy = Pagy.new(count: result[:total_count], page: page)
      @posts = result[:items]

      # Fallback to sample data if no posts exist (only when not searching)
      @posts = sample_posts if @posts.empty? && @query.blank?
    end

    def show
      @post = blog_repository.find_by_id(params[:id].to_i)

      # Check if published or fallback to sample
      if @post.nil? || !@post.published?
        @post = sample_posts.find { |p| p[:id] == params[:id].to_i }
      end

      unless @post
        render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
      end
    end

    private

    def blog_repository
      Blog::BlogPostRepository.new
    end

    def sample_posts
      [
        OpenStruct.new(
          id: 1,
          title: "2024년 비즈니스 트렌드 총정리",
          excerpt: "올해 가장 주목받은 비즈니스 트렌드와 2025년 전망에 대해 분석합니다.",
          content: "2024년은 AI와 자동화가 비즈니스 전반에 큰 영향을 미친 해였습니다...",
          author: "김대표",
          published_at: Date.parse("2024-12-22"),
          category: "트렌드",
          image_url: "https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800"
        ),
        OpenStruct.new(
          id: 2,
          title: "성공적인 프로젝트 관리 비결",
          excerpt: "L-BIZ Partners가 프로젝트를 성공으로 이끄는 핵심 노하우를 공개합니다.",
          content: "성공적인 프로젝트 관리의 핵심은 명확한 목표 설정과 지속적인 커뮤니케이션입니다...",
          author: "박매니저",
          published_at: Date.parse("2024-12-18"),
          category: "프로젝트",
          image_url: "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=800"
        ),
        OpenStruct.new(
          id: 3,
          title: "클라이언트와의 신뢰 구축하기",
          excerpt: "오랜 파트너십을 유지하는 비결과 클라이언트 관계 관리 팁을 소개합니다.",
          content: "클라이언트와의 신뢰는 하루아침에 만들어지지 않습니다...",
          author: "이컨설턴트",
          published_at: Date.parse("2024-12-14"),
          category: "비즈니스",
          image_url: "https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800"
        ),
        OpenStruct.new(
          id: 4,
          title: "스타트업 컨설팅 사례 연구",
          excerpt: "최근 진행한 스타트업 컨설팅 프로젝트의 성과와 인사이트를 공유합니다.",
          content: "지난 6개월간 진행한 스타트업 A사의 컨설팅 프로젝트는 큰 성과를 거두었습니다...",
          author: "최분석가",
          published_at: Date.parse("2024-12-10"),
          category: "케이스스터디",
          image_url: "https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800"
        ),
        OpenStruct.new(
          id: 5,
          title: "L-BIZ Partners 팀 소개",
          excerpt: "우리 팀의 전문성과 협업 문화에 대해 소개합니다.",
          content: "L-BIZ Partners는 다양한 분야의 전문가들로 구성되어 있습니다...",
          author: "정팀장",
          published_at: Date.parse("2024-12-05"),
          category: "회사소식",
          image_url: "https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800"
        ),
        OpenStruct.new(
          id: 6,
          title: "업무 효율화를 위한 도구 추천",
          excerpt: "생산성을 높여주는 필수 비즈니스 도구들을 소개합니다.",
          content: "효율적인 업무 환경을 위해 다양한 도구들을 활용하는 것이 중요합니다...",
          author: "김대표",
          published_at: Date.parse("2024-12-01"),
          category: "팁",
          image_url: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=800"
        )
      ]
    end
  end
end
