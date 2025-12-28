# frozen_string_literal: true

module Admin
  class BlogController < BaseController
    before_action :set_post, only: [ :show, :edit, :update, :destroy ]

    def index
      page = (params[:page] || 1).to_i
      result = blog_repository.find_all_paginated(page: page)

      @pagy = Pagy.new(count: result[:total_count], page: page)
      @posts = result[:items]
    end

    def show
    end

    def new
      @post = BlogPostRecord.new(published: false)
    end

    def create
      entity = Blog::Entities::BlogPost.new(
        id: nil,
        title: post_params[:title],
        excerpt: post_params[:excerpt],
        content: post_params[:content],
        author: post_params[:author],
        category: post_params[:category],
        image_url: post_params[:image_url],
        published: post_params[:published] == "1"
      )

      blog_repository.save(entity, image: post_params[:image])
      redirect_to admin_blog_index_path, notice: "블로그 글이 생성되었습니다."
    rescue ActiveRecord::RecordInvalid => e
      @post = BlogPostRecord.new(post_params.except(:image))
      @errors = [ e.message ]
      render :new, status: :unprocessable_entity
    end

    def edit
    end

    def update
      entity = Blog::Entities::BlogPost.new(
        id: @post.id,
        title: post_params[:title].presence || @post.title,
        excerpt: post_params[:excerpt].presence || @post.excerpt,
        content: post_params[:content].presence || @post.content,
        author: post_params[:author].presence || @post.author,
        category: post_params[:category].presence || @post.category,
        image_url: post_params[:image_url].presence || @post.image_url,
        published: post_params.key?(:published) ? post_params[:published] == "1" : @post.published
      )

      blog_repository.save(entity, image: post_params[:image])
      redirect_to admin_blog_index_path, notice: "블로그 글이 수정되었습니다."
    end

    def destroy
      blog_repository.delete(@post.id)
      redirect_to admin_blog_index_path, notice: "블로그 글이 삭제되었습니다."
    end

    private

    def set_post
      @post = BlogPostRecord.find_by(id: params[:id].to_i)
      render file: Rails.public_path.join("404.html"), status: :not_found, layout: false unless @post
    end

    def blog_repository
      Blog::BlogPostRepository.new
    end

    def post_params
      params.require(:blog_post).permit(:title, :excerpt, :content, :author, :category, :image_url, :image, :published)
    end
  end
end
