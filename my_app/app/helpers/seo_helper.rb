# frozen_string_literal: true

module SeoHelper
  # Default site information
  SITE_NAME = "L-BIZ Partners"
  DEFAULT_DESCRIPTION = "L-BIZ Partners - 비즈니스 성공을 위한 최적의 파트너. 전문 컨설팅, 사업 전략, 마케팅 솔루션을 제공합니다."
  DEFAULT_KEYWORDS = "비즈니스 컨설팅, 사업 전략, 마케팅, L-BIZ Partners, 기업 컨설팅, 스타트업 지원"
  DEFAULT_IMAGE = "/icon.png"

  # Base URL (should be set via environment variable in production)
  def site_url
    @site_url ||= ENV.fetch("SITE_URL", request.base_url)
  end

  # Set default meta tags for a page
  def default_meta_tags
    {
      site: SITE_NAME,
      title: "비즈니스 성공을 위한 최적의 파트너",
      description: DEFAULT_DESCRIPTION,
      keywords: DEFAULT_KEYWORDS,
      charset: "utf-8",
      viewport: "width=device-width, initial-scale=1",
      separator: " | ",
      reverse: true,
      icon: [
        { href: "/icon.png", type: "image/png" },
        { href: "/icon.svg", type: "image/svg+xml" }
      ],
      canonical: request.original_url,
      og: default_open_graph,
      twitter: default_twitter_card
    }
  end

  # Open Graph defaults
  def default_open_graph
    {
      site_name: SITE_NAME,
      type: "website",
      title: :title,
      description: :description,
      url: request.original_url,
      image: full_url(DEFAULT_IMAGE),
      locale: "ko_KR"
    }
  end

  # Twitter Card defaults
  def default_twitter_card
    {
      card: "summary_large_image",
      site: "@lbizpartners",
      title: :title,
      description: :description,
      image: full_url(DEFAULT_IMAGE)
    }
  end

  # Set page meta tags
  def set_page_meta(title:, description: nil, keywords: nil, image: nil, type: "website")
    set_meta_tags(
      title: title,
      description: description || DEFAULT_DESCRIPTION,
      keywords: keywords || DEFAULT_KEYWORDS,
      og: {
        title: title,
        description: description || DEFAULT_DESCRIPTION,
        image: image ? full_url(image) : full_url(DEFAULT_IMAGE),
        type: type
      },
      twitter: {
        title: title,
        description: description || DEFAULT_DESCRIPTION,
        image: image ? full_url(image) : full_url(DEFAULT_IMAGE)
      }
    )
  end

  # Set article meta tags (for blog posts)
  def set_article_meta(title:, description:, author: nil, published_at: nil, updated_at: nil, image: nil, category: nil)
    set_meta_tags(
      title: title,
      description: description,
      og: {
        title: title,
        description: description,
        type: "article",
        image: image ? full_url(image) : full_url(DEFAULT_IMAGE),
        article: {
          author: author,
          published_time: published_at&.iso8601,
          modified_time: updated_at&.iso8601,
          section: category
        }.compact
      },
      twitter: {
        title: title,
        description: description,
        image: image ? full_url(image) : full_url(DEFAULT_IMAGE)
      }
    )
  end

  # JSON-LD Organization schema
  def organization_json_ld
    {
      "@context": "https://schema.org",
      "@type": "Organization",
      name: SITE_NAME,
      url: site_url,
      logo: full_url(DEFAULT_IMAGE),
      description: DEFAULT_DESCRIPTION,
      address: {
        "@type": "PostalAddress",
        addressLocality: "서울특별시",
        addressRegion: "강남구",
        addressCountry: "KR"
      },
      contactPoint: {
        "@type": "ContactPoint",
        telephone: "+82-2-1234-5678",
        email: "contact@lbizpartners.com",
        contactType: "customer service",
        availableLanguage: "Korean"
      },
      sameAs: [
        # Add social media URLs here
      ]
    }
  end

  # JSON-LD WebSite schema
  def website_json_ld
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      name: SITE_NAME,
      url: site_url,
      potentialAction: {
        "@type": "SearchAction",
        target: {
          "@type": "EntryPoint",
          urlTemplate: "#{site_url}/portfolios?q={search_term_string}"
        },
        "query-input": "required name=search_term_string"
      }
    }
  end

  # JSON-LD Breadcrumb schema
  def breadcrumb_json_ld(items)
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      itemListElement: items.each_with_index.map do |item, index|
        {
          "@type": "ListItem",
          position: index + 1,
          name: item[:name],
          item: item[:url] ? full_url(item[:url]) : nil
        }.compact
      end
    }
  end

  # JSON-LD Article schema (for blog posts)
  def article_json_ld(post)
    image_url = if post.respond_to?(:image) && post.image.respond_to?(:attached?) && post.image.attached?
                  rails_blob_url(post.image, only_path: false)
                elsif post.respond_to?(:image_url) && post.image_url.present?
                  post.image_url
                else
                  full_url(DEFAULT_IMAGE)
                end

    content_text = post.respond_to?(:content) ? post.content.to_s : ""
    created_time = post.respond_to?(:created_at) ? post.created_at : nil
    updated_time = post.respond_to?(:updated_at) ? post.updated_at : created_time
    author_name = post.respond_to?(:author) && post.author.present? ? post.author : SITE_NAME

    {
      "@context": "https://schema.org",
      "@type": "Article",
      headline: post.title,
      description: truncate(strip_tags(content_text), length: 160),
      image: image_url,
      author: {
        "@type": "Person",
        name: author_name
      },
      publisher: {
        "@type": "Organization",
        name: SITE_NAME,
        logo: {
          "@type": "ImageObject",
          url: full_url(DEFAULT_IMAGE)
        }
      },
      datePublished: created_time&.iso8601,
      dateModified: updated_time&.iso8601,
      mainEntityOfPage: {
        "@type": "WebPage",
        "@id": request.original_url
      }
    }.compact
  end

  # JSON-LD Product schema (for portfolio)
  def portfolio_json_ld(portfolio)
    image_url = if portfolio.respond_to?(:image) && portfolio.image.respond_to?(:attached?) && portfolio.image.attached?
                  rails_blob_url(portfolio.image, only_path: false)
                elsif portfolio.respond_to?(:image_url) && portfolio.image_url.present?
                  portfolio.image_url
                else
                  full_url(DEFAULT_IMAGE)
                end

    description_text = portfolio.respond_to?(:description) ? portfolio.description.to_s : ""
    created_time = portfolio.respond_to?(:created_at) ? portfolio.created_at : nil
    updated_time = portfolio.respond_to?(:updated_at) ? portfolio.updated_at : created_time

    result = {
      "@context": "https://schema.org",
      "@type": "CreativeWork",
      name: portfolio.title,
      description: truncate(strip_tags(description_text), length: 160),
      image: image_url,
      author: {
        "@type": "Organization",
        name: SITE_NAME
      }
    }

    result[:dateCreated] = created_time.iso8601 if created_time
    result[:dateModified] = updated_time.iso8601 if updated_time

    result
  end

  # Render JSON-LD script tag
  def json_ld_tag(data)
    tag.script(data.to_json.html_safe, type: "application/ld+json")
  end

  private

  def full_url(path)
    return path if path.start_with?("http")
    URI.join(site_url, path).to_s
  end
end
