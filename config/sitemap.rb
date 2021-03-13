require 'aws-sdk-s3'

# https://github.com/kjvarga/sitemap_generator#an-example-of-using-an-adapter
SitemapGenerator::Sitemap.sitemaps_host = "https://#{Rails.application.credentials.dig(:digitalocean, :bucket)}.#{Rails.application.credentials.dig(:digitalocean, :region)}.digitaloceanspaces.com/"
SitemapGenerator::Sitemap.public_path   = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(Rails.application.credentials.dig(:digitalocean, :bucket),
  aws_access_key_id: Rails.application.credentials.dig(:digitalocean, :access_key_id),
  aws_secret_access_key: Rails.application.credentials.dig(:digitalocean, :secret_access_key),
  aws_region:  Rails.application.credentials.dig(:digitalocean, :region),
  aws_endpoint: "https://#{Rails.application.credentials.dig(:digitalocean, :region)}.digitaloceanspaces.com"
)

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.mysitearchive.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  add posts_path, :priority => 0.7, :changefreq => 'monthly'
  Post.published.each do |post|
    add post_path(post), :lastmod => post.updated_at
  end

  add pricing_path
  add faqs_path
  add features_path
end

