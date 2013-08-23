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

  def shedule_code_to_s(shedule_code)
    shedule_codes_mapping = {0 => 'very often', 1 => 'often',
                             2 => 'regular', 3 => 'rarely',
                             4 => 'very rarely', 5 => 'never'}
    shedule_codes_mapping[shedule_code]
  end

end
