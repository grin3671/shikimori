class CollectionsQuery < SimpleQueryBase
  pattr_initialize :locale
  decorate_page true

private

  def query
    Collection
      .includes(:topics)
      .where(locale: @locale)
      .where(state: :published)
      .order(:id)
  end
end
