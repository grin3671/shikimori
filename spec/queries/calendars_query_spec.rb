describe CalendarsQuery do
  let(:query) { CalendarsQuery.new }

  let!(:anime1) { create :anime, name: '1' }

  let!(:anime2) { create :ongoing_anime, name: '2', aired_on: Time.zone.now - 1.day }
  let!(:anime3) { create :ongoing_anime, name: '3', duration: 20 }
  let!(:anime4) { create :ongoing_anime, name: '4', kind: 'ONA' }
  let!(:anime5) { create :ongoing_anime, name: '5', episodes_aired: 0, aired_on: Time.zone.now - 1.day - 1.month }

  let!(:anime6) { create :anons_anime, name: '6' }
  let!(:anime7) { create :anons_anime, name: '7' }
  let!(:anime8) { create :anons_anime, name: '8', aired_on: Time.zone.now + 1.week }

  it { expect(query.send(:fetch_ongoings).map(&:id)).to eq [anime2.id, anime3.id] }
  it { expect(query.send(:fetch_anonses).map(&:id)).to eq [anime6.id, anime7.id, anime8.id] }

  it { expect(query.fetch).to eq [anime2, anime6, anime7, anime8] }
  it { expect(query.fetch_grouped).to have(2).items }
end
