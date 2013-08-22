module ResourcesHelper

  def get_tags_string(resource, all_tags)
    tags = all_tags.map do |key, value|
      value if resource.tags.include? key
    end
    tag_string = tags.compact.inject('') do |string, tag_name|
      string+"#{tag_name}; "
    end
    tag_string
  end

end
