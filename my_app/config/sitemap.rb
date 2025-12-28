# frozen_string_literal: true

# sitemap_generator configuration
# https://github.com/kjvarga/sitemap_generator

SitemapGenerator::Sitemap.default_host = ENV.fetch("SITEMAP_HOST", "https://lbizpartners.com")
SitemapGenerator::Sitemap.public_path = "public"
SitemapGenerator::Sitemap.compress = true

SitemapGenerator::Sitemap.create do
  # Root page (home)
  add root_path, changefreq: "weekly", priority: 1.0

  # Static pages with anchor sections
  add "/#about", changefreq: "monthly", priority: 0.8
  add "/#services", changefreq: "monthly", priority: 0.8

  # Contact page
  add new_contact_path, changefreq: "monthly", priority: 0.7

  # Portfolio pages
  add portfolios_path, changefreq: "weekly", priority: 0.9
  PortfolioRecord.published.find_each do |portfolio|
    add portfolio_path(portfolio), lastmod: portfolio.updated_at, changefreq: "monthly", priority: 0.8
  end

  # Blog pages
  add blog_index_path, changefreq: "daily", priority: 0.9
  BlogPostRecord.published.find_each do |post|
    add blog_path(post), lastmod: post.updated_at, changefreq: "weekly", priority: 0.8
  end

  # Contents pages
  add contents_path, changefreq: "weekly", priority: 0.8
end
