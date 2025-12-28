# frozen_string_literal: true

require "test_helper"

class ImageVariantsTest < ActiveSupport::TestCase
  def setup
    @portfolio = PortfolioRecord.create!(
      title: "Test Portfolio",
      description: "Test description",
      client: "Test Client",
      published: true
    )

    @blog_post = BlogPostRecord.create!(
      title: "Test Blog Post",
      content: "Test content",
      author: "Test Author",
      category: "Test",
      published: true,
      published_at: Time.current
    )
  end

  # PortfolioRecord variant tests
  test "portfolio thumbnail_url returns nil when no image attached" do
    assert_nil @portfolio.thumbnail_url
  end

  test "portfolio medium_url returns nil when no image attached" do
    assert_nil @portfolio.medium_url
  end

  test "portfolio large_url returns nil when no image attached" do
    assert_nil @portfolio.large_url
  end

  test "portfolio thumbnail_url returns path when image attached" do
    attach_test_image(@portfolio)
    assert_not_nil @portfolio.thumbnail_url
    assert @portfolio.thumbnail_url.is_a?(String)
  end

  test "portfolio medium_url returns path when image attached" do
    attach_test_image(@portfolio)
    assert_not_nil @portfolio.medium_url
    assert @portfolio.medium_url.is_a?(String)
  end

  test "portfolio large_url returns path when image attached" do
    attach_test_image(@portfolio)
    assert_not_nil @portfolio.large_url
    assert @portfolio.large_url.is_a?(String)
  end

  # BlogPostRecord variant tests
  test "blog post thumbnail_url returns nil when no image attached" do
    assert_nil @blog_post.thumbnail_url
  end

  test "blog post medium_url returns nil when no image attached" do
    assert_nil @blog_post.medium_url
  end

  test "blog post large_url returns nil when no image attached" do
    assert_nil @blog_post.large_url
  end

  test "blog post thumbnail_url returns path when image attached" do
    attach_test_image(@blog_post)
    assert_not_nil @blog_post.thumbnail_url
    assert @blog_post.thumbnail_url.is_a?(String)
  end

  test "blog post medium_url returns path when image attached" do
    attach_test_image(@blog_post)
    assert_not_nil @blog_post.medium_url
    assert @blog_post.medium_url.is_a?(String)
  end

  test "blog post large_url returns path when image attached" do
    attach_test_image(@blog_post)
    assert_not_nil @blog_post.large_url
    assert @blog_post.large_url.is_a?(String)
  end

  private

  def attach_test_image(record)
    record.image.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test_image.png")),
      filename: "test_image.png",
      content_type: "image/png"
    )
  end
end
