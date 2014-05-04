class TopicsQuery
  def initialize section, user, linked = nil
    @section = section
    @user = user
    @linked = linked
  end

  def fetch page, limit
    query = @section ? by_section(prepare_query) : prepare_query
    paginate exclude_generated(by_linked query), page, limit
  end

private
  def prepare_query
    Entry
      .with_viewed(@user)
      .includes(:section)
      .order_default
  end

  def by_section query
    case @section.permalink
      when Section::All.permalink
        if @user
          query.where "type != ? or (type = ? and #{Entry.table_name}.id in (?))", GroupComment.name, GroupComment.name, user_subscription_ids
        else
          query.where.not type: GroupComment.name
        end

      when Section::Feed.permalink
        query.where id: user_subscription_ids

      when Section::News.permalink
        query.where type: [AnimeNews.name, MangaNews.name]

      else
        query.where section_id: @section.id
    end
  end

  def by_linked query
    if @linked
      query.where linked_id: @linked.id, linked_type: @linked.class.name
    else
      query
    end
  end

  def exclude_generated query
    query.send @section && @section.permalink == 'news' ? :wo_episodes : :wo_generated
  end

  def paginate query, page, limit
    query
      .offset(limit * (page-1))
      .limit(limit + 1)
  end

  def user_subscription_ids
    Subscription
      .where(user_id: @user.id, target_type: Entry::Types)
      .pluck(:target_id)
  end
end
