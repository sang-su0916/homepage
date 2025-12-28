# frozen_string_literal: true

require "test_helper"

module Public
  class BlogControllerTest < ActionDispatch::IntegrationTest
    setup do
      @published_post = BlogPostRecord.create!(
        title: "공개 블로그 글",
        excerpt: "공개된 글의 요약입니다.",
        content: "공개된 블로그 글의 본문입니다.",
        author: "홍길동",
        category: "기술",
        published: true,
        published_at: Time.current
      )
      @unpublished_post = BlogPostRecord.create!(
        title: "비공개 블로그 글",
        excerpt: "비공개 글",
        content: "비공개 본문",
        published: false
      )
    end

    test "블로그 목록 조회" do
      get blog_index_path

      assert_response :success
      # 첫 번째 글은 featured로 h2에 표시됨
      assert_select "h2", /공개 블로그 글/
    end

    test "비공개 블로그는 목록에 표시되지 않음" do
      get blog_index_path

      assert_response :success
      # 비공개 글은 h2, h3 어디에도 표시되지 않음
      assert_select "h2", text: /비공개 블로그 글/, count: 0
      assert_select "h3", text: /비공개 블로그 글/, count: 0
    end

    test "블로그 상세 조회" do
      get blog_path(id: @published_post.id)

      assert_response :success
      assert_select "h1", /공개 블로그 글/
    end

    test "비공개 블로그 상세 조회 시 샘플 데이터 또는 404" do
      get blog_path(id: @unpublished_post.id)

      # 비공개 글은 샘플 데이터 fallback 또는 404
      assert_includes [ 200, 404 ], response.status
    end

    test "존재하지 않는 블로그 조회 시 샘플 fallback 또는 404" do
      get blog_path(id: 99999)

      # 존재하지 않는 ID는 샘플 데이터에서 찾거나 404
      assert_includes [ 200, 404 ], response.status
    end

    test "블로그 목록 페이지네이션" do
      # 추가 글 생성
      15.times do |i|
        BlogPostRecord.create!(
          title: "페이지네이션 테스트 #{i}",
          published: true,
          published_at: Time.current
        )
      end

      get blog_index_path

      assert_response :success
    end

    test "블로그 목록 2페이지 조회" do
      15.times do |i|
        BlogPostRecord.create!(
          title: "글 #{i}",
          published: true,
          published_at: Time.current
        )
      end

      get blog_index_path, params: { page: 2 }

      assert_response :success
    end

    test "블로그 목록이 비어있으면 샘플 데이터 표시" do
      BlogPostRecord.destroy_all

      get blog_index_path

      assert_response :success
      # 샘플 데이터가 표시되어야 함
      assert_select "article"
    end

    test "블로그 상세에서 작성자 표시" do
      get blog_path(id: @published_post.id)

      assert_response :success
      # 작성자는 p 태그 안에 표시됨
      assert_select "p.font-medium", /홍길동/
    end

    test "블로그 상세에서 카테고리 표시" do
      get blog_path(id: @published_post.id)

      assert_response :success
      assert_select "span.bg-indigo-100", /기술/
    end

    test "제목으로 블로그 검색" do
      BlogPostRecord.create!(
        title: "Rails 8 새로운 기능",
        excerpt: "Rails 8 소개",
        content: "Rails 8 내용",
        published: true,
        published_at: Time.current
      )

      get blog_index_path, params: { q: "Rails" }

      assert_response :success
      assert_select "h3", /Rails 8 새로운 기능/
      assert_select "p", /\"Rails\" 검색 결과/
    end

    test "작성자로 블로그 검색" do
      get blog_index_path, params: { q: "홍길동" }

      assert_response :success
      # 홍길동이 작성한 공개 블로그 글 표시
      assert_select "h2, h3", /공개 블로그 글/
    end

    test "검색 결과가 없을 때 메시지 표시" do
      get blog_index_path, params: { q: "존재하지않는키워드xyz" }

      assert_response :success
      assert_select "h2", /검색 결과가 없습니다/
    end

    test "검색 시 비공개 블로그는 제외됨" do
      get blog_index_path, params: { q: "비공개" }

      assert_response :success
      assert_select "h2, h3", text: /비공개 블로그 글/, count: 0
    end

    test "빈 검색어로 조회하면 전체 목록 표시" do
      get blog_index_path, params: { q: "" }

      assert_response :success
      # 샘플 데이터 또는 실제 데이터 표시
      assert_select "h2"
    end
  end
end
