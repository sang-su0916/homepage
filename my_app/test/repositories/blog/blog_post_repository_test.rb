# frozen_string_literal: true

require "test_helper"

module Blog
  class BlogPostRepositoryTest < ActiveSupport::TestCase
    setup do
      @repository = BlogPostRepository.new
    end

    test "블로그 글을 저장하고 조회할 수 있다" do
      entity = Entities::BlogPost.new(
        id: nil,
        title: "테스트 블로그 글",
        excerpt: "테스트 요약",
        content: "테스트 본문입니다.",
        author: "테스트 작성자",
        category: "테스트",
        image_url: "/images/test.jpg",
        published: true
      )

      saved = @repository.save(entity)

      assert_not_nil saved.id
      assert_equal "테스트 블로그 글", saved.title
      assert_equal "테스트 요약", saved.excerpt
      assert_equal "테스트 작성자", saved.author
      assert saved.published?
      assert_not_nil saved.published_at

      found = @repository.find_by_id(saved.id)
      assert_equal saved.id, found.id
      assert_equal saved.title, found.title
    end

    test "공개된 블로그 글만 조회할 수 있다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "공개글1", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "비공개글", published: false))
      @repository.save(Entities::BlogPost.new(id: nil, title: "공개글2", published: true))

      published = @repository.find_published
      assert_equal 2, published.size
      assert published.all?(&:published?)
    end

    test "모든 블로그 글을 조회할 수 있다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "글1", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "글2", published: false))
      @repository.save(Entities::BlogPost.new(id: nil, title: "글3", published: true))

      all_posts = @repository.find_all
      assert_equal 3, all_posts.size
    end

    test "블로그 글을 수정할 수 있다" do
      saved = @repository.save(
        Entities::BlogPost.new(id: nil, title: "원래 제목", published: false)
      )

      updated = @repository.save(
        Entities::BlogPost.new(
          id: saved.id,
          title: "수정된 제목",
          excerpt: "새 요약",
          published: true
        )
      )

      assert_equal saved.id, updated.id
      assert_equal "수정된 제목", updated.title
      assert_equal "새 요약", updated.excerpt
      assert updated.published?
    end

    test "블로그 글을 삭제할 수 있다" do
      saved = @repository.save(
        Entities::BlogPost.new(id: nil, title: "삭제테스트", published: false)
      )

      @repository.delete(saved.id)
      assert_nil @repository.find_by_id(saved.id)
    end

    test "존재하지 않는 글을 조회하면 nil을 반환한다" do
      found = @repository.find_by_id(99999)
      assert_nil found
    end

    test "공개 글을 페이지네이션으로 조회할 수 있다" do
      15.times do |i|
        @repository.save(
          Entities::BlogPost.new(id: nil, title: "공개글#{i}", published: true)
        )
      end
      @repository.save(Entities::BlogPost.new(id: nil, title: "비공개", published: false))

      result = @repository.find_published_paginated(page: 1, limit: 10)
      assert_equal 10, result[:items].size
      assert_equal 15, result[:total_count]

      result2 = @repository.find_published_paginated(page: 2, limit: 10)
      assert_equal 5, result2[:items].size
    end

    test "모든 글을 페이지네이션으로 조회할 수 있다" do
      12.times do |i|
        @repository.save(
          Entities::BlogPost.new(id: nil, title: "글#{i}", published: i.even?)
        )
      end

      result = @repository.find_all_paginated(page: 1, limit: 10)
      assert_equal 10, result[:items].size
      assert_equal 12, result[:total_count]

      result2 = @repository.find_all_paginated(page: 2, limit: 10)
      assert_equal 2, result2[:items].size
    end

    test "공개 시 published_at이 자동 설정된다" do
      entity = Entities::BlogPost.new(
        id: nil,
        title: "공개 시간 테스트",
        published: true
      )

      saved = @repository.save(entity)
      assert_not_nil saved.published_at
    end

    test "비공개 글은 published_at이 설정되지 않는다" do
      entity = Entities::BlogPost.new(
        id: nil,
        title: "비공개 테스트",
        published: false
      )

      saved = @repository.save(entity)
      assert_nil saved.published_at
    end

    test "제목으로 공개 블로그 글을 검색할 수 있다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "Rails 8 새로운 기능", content: "내용1", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "Django 5 업데이트", content: "내용2", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "Rails 비공개 글", content: "내용3", published: false))

      result = @repository.search_published(query: "Rails")
      assert_equal 1, result[:items].size
      assert_equal "Rails", result[:query]
    end

    test "내용으로 공개 블로그 글을 검색할 수 있다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "글1", content: "마이크로서비스 아키텍처에 대해", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "글2", content: "모놀리식 아키텍처에 대해", published: true))

      result = @repository.search_published(query: "마이크로서비스")
      assert_equal 1, result[:items].size
    end

    test "작성자로 공개 블로그 글을 검색할 수 있다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "글1", author: "홍길동", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "글2", author: "김철수", published: true))

      result = @repository.search_published(query: "홍길동")
      assert_equal 1, result[:items].size
    end

    test "카테고리로 공개 블로그 글을 검색할 수 있다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "글1", category: "기술", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "글2", category: "마케팅", published: true))

      result = @repository.search_published(query: "기술")
      assert_equal 1, result[:items].size
    end

    test "검색어가 없으면 전체 공개 블로그 글을 반환한다" do
      @repository.save(Entities::BlogPost.new(id: nil, title: "글1", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "글2", published: true))
      @repository.save(Entities::BlogPost.new(id: nil, title: "비공개", published: false))

      result = @repository.search_published(query: nil)
      assert_equal 2, result[:items].size
    end

    test "검색 결과를 페이지네이션할 수 있다" do
      15.times do |i|
        @repository.save(Entities::BlogPost.new(id: nil, title: "테스트 블로그 #{i}", published: true))
      end

      result = @repository.search_published(query: "테스트", page: 1, limit: 10)
      assert_equal 10, result[:items].size
      assert_equal 15, result[:total_count]

      result2 = @repository.search_published(query: "테스트", page: 2, limit: 10)
      assert_equal 5, result2[:items].size
    end
  end
end
