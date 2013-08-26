require 'cgi'

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid URL") unless url_valid?(value)
  end

  # Doesn't work with IP-adresses
  def url_valid?(url)
    url_parts = url.partition('//')
    url_parts = url_parts[2].partition('/')
    PublicSuffix.valid?(url_parts[0])
  end
end