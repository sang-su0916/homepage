# frozen_string_literal: true

require "test_helper"

module Blog
  class BlogPostEntityTest < ActiveSupport::TestCase
    test "블로그 글을 생성할 수 있다" do
      post = Entities::BlogPost.new(
        id: 1,
        title: "Rails 8 새로운 기능 소개",
        excerpt: "Rails 8의 주요 변경사항을 알아봅니다.",
        content: "Rails 8이 출시되었습니다. 이번 버전에서는...",
        author: "홍길동",
        category: "기술",
        image_url: "/images/blog/rails8.jpg",
        published: true,
        published_at: Time.current,
        created_at: Time.current
      )

      assert_equal 1, post.id
      assert_equal "Rails 8 새로운 기능 소개", post.title
      assert_equal "Rails 8의 주요 변경사항을 알아봅니다.", post.excerpt
      assert_equal "홍길동", post.author
      assert_equal "기술", post.category
      assert post.published?
    end

    test "블로그 글은 공개/비공개 상태를 가진다" do
      published = Entities::BlogPost.new(
        id: 1,
        title: "공개 글",
        published: true
      )

      draft = Entities::BlogPost.new(
        id: 2,
        title: "비공개 글",
        published: false
      )

      assert published.published?
      assert_not draft.published?
    end

    test "블로그 글의 기본값이 올바르게 설정된다" do
      post = Entities::BlogPost.new(
        id: nil,
        title: "기본값 테스트"
      )

      assert_nil post.id
      assert_nil post.excerpt
      assert_nil post.content
      assert_nil post.author
      assert_nil post.category
      assert_nil post.image_url
      assert_not post.published?
      assert_nil post.published_at
      assert_nil post.created_at
    end

    test "블로그 글은 제목이 필수이다" do
      post = Entities::BlogPost.new(
        id: 1,
        title: "필수 제목"
      )

      assert_equal "필수 제목", post.title
    end
  end
end
