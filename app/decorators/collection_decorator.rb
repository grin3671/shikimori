class CollectionDecorator < DbEntryDecorator
  instance_cache :cached_links, :entries_sample, :groups, :texts, :bbcode_links

  SAMPLE_LIMIT = 6

  def groups
    cached_links.each_with_object({}) do |link, memo|
      memo[link.group] ||= []
      memo[link.group] << link.send(kind).decorate
    end
  end

  def texts
    cached_links
      .select { |link| link.text.present? }
      .each_with_object({}) do |link, memo|
        memo[link.linked_id] = BbCodes::Text.call link.text
      end
  end

  def entries_sample
    if links.size.positive?
      loaded_links.limit(SAMPLE_LIMIT).map { |v| v.send(kind).decorate }
    else
      bbcode_entries_sample
    end
  end

  def size
    if links.size.positive?
      links.size
    else
      bbcode_links.size
    end
  end

private

  def cached_links
    loaded_links
  end

  def loaded_links
    links.includes(kind).order(:id)
  end

  def bbcode_links
    text
      .scan(BbCodes::Tags::EntriesTag::REGEXP)
      .map(&:second)
      .flat_map { |v| v.split(',') }
      .uniq
  end

  def bbcode_entries_sample
    kind.classify.constantize
      .where(id: bbcode_links.take(SAMPLE_LIMIT))
      .sort_by { |v| bbcode_links.index v.id }
      .map(&:decorate)
  end
end
