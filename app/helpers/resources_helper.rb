module ResourcesHelper
  def clean_tags(tags_string)
    unless tags_string.empty?
      #tags_string.strip
      tags = tags_string.split(';').inject([]) do |tags, dirty_tag|
        if dirty_tag.strip.empty?
          tags
        else
          tags.push dirty_tag.strip
        end
      end
      tags
    else
      []
    end
  end

  def resourceInfoToResource(resource_info, tags, user_id)
    resource_info[:tags] = clean_tags(resource_info[:tags])

    # tags - all user tags ({ id: name })
    # new_tags - resource tags, which no exist in db (only names)
    new_tags = resource_info[:tags] - tags.values
    # old_tags - resource tags, which already exist in db (only names)
    old_tags = resource_info[:tags] - new_tags
    # another way with the same result:
    # old_tags = resource_info[:tags] & tags.values

    tag_ids = tags.map do |key, value|
      key if old_tags.include? value
    end

    tag_ids.compact!

    new_tags.each do |tag|
      tag_id = DatabaseHelper.add_tag(user_id, tag).to_i
      tag_ids.push(tag_id) if tag_id > 0
    end

    resource_info[:tags] = tag_ids

    resource = Resource.new(resource_info)
    resource.user_id = user_id
    resource.schedule_code = 0
    #resource.dom_path = '/'
    resource
  end

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
