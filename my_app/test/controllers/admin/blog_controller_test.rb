# frozen_string_literal: true

require "test_helper"

module Admin
  class BlogControllerTest < ActionDispatch::IntegrationTest
    setup do
      @password = "secure_password123"
      @admin = AdminRecord.create!(
        email: "admin@lbiz.co.kr",
        password_digest: BCrypt::Password.create(@password)
      )
      login_as_admin

      @post = BlogPostRecord.create!(
        title: "기존 블로그 글",
        excerpt: "기존 요약",
        content: "기존 본문",
        author: "관리자",
        category: "기술",
        published: false
      )
    end

    test "비로그인 상태에서 접근 시 로그인 페이지로 리다이렉트" do
      delete admin_session_path
      get admin_blog_index_path

      assert_redirected_to admin_login_path
    end

    test "블로그 목록 조회" do
      get admin_blog_index_path

      assert_response :success
      assert_select "table"
      assert_select "td", /기존 블로그 글/
    end

    test "블로그 생성 폼 페이지" do
      get new_admin_blog_path

      assert_response :success
      assert_select "form"
      assert_select "input[name='blog_post[title]']"
    end

    test "블로그 생성 성공" do
      assert_difference "BlogPostRecord.count", 1 do
        post admin_blog_index_path, params: {
          blog_post: {
            title: "새 블로그 글",
            excerpt: "새 요약",
            content: "새 본문 내용입니다.",
            author: "홍길동",
            category: "마케팅",
            published: "1"
          }
        }
      end

      assert_redirected_to admin_blog_index_path
      follow_redirect!
      assert_select ".bg-green-100"
    end

    test "유효하지 않은 데이터로 블로그 생성 실패" do
      assert_no_difference "BlogPostRecord.count" do
        post admin_blog_index_path, params: {
          blog_post: { title: "" }
        }
      end

      assert_response :unprocessable_entity
      assert_select ".bg-red-50"
    end

    test "블로그 상세 조회" do
      get admin_blog_path(@post)

      assert_response :success
      assert_select "h1", /기존 블로그 글/
    end

    test "블로그 수정 폼 페이지" do
      get edit_admin_blog_path(@post)

      assert_response :success
      assert_select "input[value='기존 블로그 글']"
    end

    test "블로그 수정 성공" do
      patch admin_blog_path(@post), params: {
        blog_post: { title: "수정된 제목" }
      }

      assert_redirected_to admin_blog_index_path
      @post.reload
      assert_equal "수정된 제목", @post.title
    end

    test "블로그 삭제" do
      assert_difference "BlogPostRecord.count", -1 do
        delete admin_blog_path(@post)
      end

      assert_redirected_to admin_blog_index_path
    end

    test "이미지와 함께 블로그 생성" do
      image = fixture_file_upload("test_image.png", "image/png")

      assert_difference "BlogPostRecord.count", 1 do
        post admin_blog_index_path, params: {
          blog_post: {
            title: "이미지 블로그",
            content: "이미지 포함 글",
            image: image
          }
        }
      end

      assert_redirected_to admin_blog_index_path
      blog = BlogPostRecord.last
      assert blog.image.attached?
    end

    test "공개 상태로 저장 시 published_at 설정" do
      post admin_blog_index_path, params: {
        blog_post: {
          title: "공개 글",
          content: "내용",
          published: "1"
        }
      }

      blog = BlogPostRecord.last
      assert blog.published
      assert_not_nil blog.published_at
    end

    test "비공개 상태로 저장 시 published_at은 nil" do
      post admin_blog_index_path, params: {
        blog_post: {
          title: "비공개 글",
          content: "내용",
          published: "0"
        }
      }

      blog = BlogPostRecord.last
      assert_not blog.published
      assert_nil blog.published_at
    end

    test "존재하지 않는 블로그 조회 시 404" do
      get admin_blog_path(id: 99999)

      assert_response :not_found
    end

    private

    def login_as_admin
      post admin_session_path, params: {
        email: "admin@lbiz.co.kr",
        password: @password
      }
    end
  end
end
