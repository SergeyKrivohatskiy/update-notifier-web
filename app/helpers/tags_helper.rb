module TagsHelper
  def clean_tags(tags_string)
    unless tags_string.empty?
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

  # Parse tag string, get tag ids for old resources and adds new tags.
  # Returns tag ids for tag names from tag_string
  def add_new_tags(tag_string, user_id)
    tags = DatabaseHelper.tags(user_id)
    res_tags = clean_tags(tag_string)
    # tags - all user tags ({ id: name })
    # new_tags - resource tags, which no exist in db (only names)
    new_tags = res_tags - tags.values
    # old_tags - resource tags, which already exist in db (only names)
    old_tags = res_tags - new_tags
    # another way with the same result:
    # old_tags = resource_info[:tags] & tags.values

    tag_ids = tags.map do |key, value|
      key if old_tags.include? value
    end

    tag_ids.compact!

    new_tags.each do |tag_name|
      # TODO exception if is not valid and not add resource
      tag = Tag.new({user_id: user_id, name: tag_name})
      if tag.valid?
        tag_id = DatabaseHelper.add_tag(tag).to_i
        tag_ids.push(tag_id) if tag_id > 0
      #else
      #  raise ValidationError, tag.errors.full_messages
      end
    end
    tag_ids
  end
end
