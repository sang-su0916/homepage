# frozen_string_literal: true

# MetaTags configuration
# https://github.com/kpumuk/meta-tags

MetaTags.configure do |config|
  # Title configuration
  config.title_limit = 70
  config.description_limit = 160
  config.keywords_limit = 255

  # Truncate on word boundary
  config.truncate_on_natural_separator = " "

  # Minify output
  config.minify_output = true
end
