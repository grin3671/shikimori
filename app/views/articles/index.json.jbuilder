json.content JsExports::Supervisor.instance.sweep(
  render(
    partial: 'topics/topic',
    collection: @collection,
    formats: :html,
    as: :topic_view,
    cached: true
  )
)

if @collection.next_page?
  json.postloader render(
    partial: 'blocks/postloader',
    locals: {
      filter: 'b-article-topic',
      next_url: articles_url(page: @collection.next_page, search: params[:search]),
      prev_url: @collection.prev_page? ?
        articles_url(page: @collection.prev_page, search: params[:search]) :
        nil
    },
    formats: :html
  )
end

json.JS_EXPORTS JsExports::Supervisor.instance.export(current_user)
