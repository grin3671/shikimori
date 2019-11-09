describe Elasticsearch::Query::Article, :vcr do
  # include_context :disable_vcr
  include_context :chewy_urgent
  include_context :chewy_indexes, %i[articles]
  # include_context :chewy_logger

  subject { described_class.call phrase: phrase, limit: ids_limit, locale: locale }

  let!(:article_1) { create :article, name: 'test', locale: 'ru' }
  let!(:article_2) { create :article, name: 'test zxct', locale: 'ru' }
  let!(:article_3) { create :article, name: 'test 2', locale: 'en' }

  let(:ids_limit) { 10 }
  let(:phrase) { 'test' }
  let(:locale) { 'ru' }

  it { is_expected.to have_keys [article_1.id, article_2.id] }
end
