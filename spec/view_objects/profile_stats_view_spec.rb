describe ProfileStatsView do
  let(:user) { create :user }

  let(:stats) { ProfileStatsView.new spent_time: spent_time,
    anime_spent_time: anime_spent_time, manga_spent_time: manga_spent_time,
    user: user }
  let(:anime_spent_time) { }
  let(:manga_spent_time) { }
  let(:spent_time) { }

  describe '#spent_percent' do
    let(:spent_time) { SpentTime.new interval }
    subject { stats.spent_time_percent }

    context 'none' do
      let(:interval) { 0 }
      it { should be_zero }
    end

    context 'week' do
      let(:interval) { 7 }
      it { should eq 10 }
    end

    context '18.5 days' do
      let(:interval) { 18.5 }
      it { should eq 20 }
    end

    context 'month' do
      let(:interval) { 30 }
      it { should eq 30 }
    end

    context '2 months' do
      let(:interval) { 2 * 30 }
      it { should eq 40 }
    end

    context '3 months' do
      let(:interval) { 3 * 30 }
      it { should eq 50 }
    end

    context '4.5 months' do
      let(:interval) { 4.5 * 30 }
      it { should eq 60 }
    end

    context '6 months' do
      let(:interval) { 6 * 30 }
      it { should eq 70 }
    end

    context '9 months' do
      let(:interval) { 9 * 30 }
      it { should eq 80 }
    end

    context 'year' do
      let(:interval) { 365 }
      it { should eq 90 }
    end

    context '1.25 years' do
      let(:interval) { 365 * 1.25 }
      it { should eq 95 }
    end

    context '1.5 years' do
      let(:interval) { 365 * 2 }
      it { should eq 100 }
    end
  end

  describe '#spent_time_in_words' do
    let(:spent_time) { SpentTime.new interval }
    subject { stats.spent_time_in_words }

    context 'none' do
      let(:interval) { 0 }
      it { should eq '0 часов' }
    end

    context '30 minutes' do
      let(:interval) { 1 / 24.0 / 2 }
      it { should eq '30 минут' }
    end

    context '1 hour' do
      let(:interval) { 1 / 24.0 }
      it { should eq '1 час' }
    end

    context '2.51 days' do
      let(:interval) { 2.5 }
      it { should eq '2 дня и 12 часов' }
    end

    context '3 weeks' do
      let(:interval) { 21 }
      it { should eq '3 недели' }
    end

    context '5.678 months' do
      let(:interval) { 5.678 * 30 }
      it { should eq '5 месяцев и 2 недели' }
    end

    context '1.25 years' do
      let(:interval) { 365 * 1.25 }
      it { should eq '1 год и 3 месяца' }
    end
  end

  describe '#spent_time_in_days' do
    let(:anime_spent_time) { SpentTime.new anime_interval }
    let(:manga_spent_time) { SpentTime.new manga_interval }
    let(:spent_time) { SpentTime.new(anime_interval + manga_interval) }

    let(:manga_interval) { 0 }
    subject { stats.spent_time_in_days }

    context 'none' do
      let(:anime_interval) { 0 }
      it { should eq 'Всего 0 дней' }
    end

    context '30 minutes' do
      let(:anime_interval) { 1 / 24.0 / 2 }
      it { should eq 'Всего 0 дней' }
    end

    context '1 hour' do
      let(:anime_interval) { 1 / 24.0 }
      it { should eq 'Всего 0 дней' }
    end

    context '2.5 hours' do
      let(:anime_interval) { 1 / 24.0 * 2.5 }
      it { should eq 'Всего 0.1 дней' }
    end

    context '2.5 days' do
      let(:anime_interval) { 1.5 }
      let(:manga_interval) { 1.1 }
      it { should eq 'Всего 2.6 дней: 1.5 дней аниме и 1.1 дней манги' }
    end

    context '10.50 days' do
      let(:anime_interval) { 10.5 }
      it { should eq '10 дней аниме' }
    end

    context '3 weeks' do
      let(:anime_interval) { 0 }
      let(:manga_interval) { 21 }
      it { should eq '21 день манги' }
    end

    context '1.25 years' do
      let(:anime_interval) { 365 * 1.25 }
      it { should eq '456 дней аниме' }
    end
  end

  describe '#comments_count' do
    let(:topic) { create :topic, user: user }
    let!(:comment) { create_list :comment, 2, user: user, commentable: topic }
    let!(:comment_2) { create :comment, commentable: topic }
    subject { stats.comments_count }

    it { should eq 2 }
  end

  describe '#summaries_count' do
    let(:topic) { create :topic, user: user }
    let!(:comment) { create :comment, :review, user: user, commentable: topic }
    let!(:comment_2) { create :comment, user: user, commentable: topic }
    subject { stats.summaries_count }

    it { should eq 1 }
  end

  describe '#reviews_count' do
    let!(:review) { create :review, user: user }
    let!(:review_2) { create :review }
    subject { stats.reviews_count }

    it { should eq 1 }
  end

  describe '#content_changes_count' do
    let(:anime) { build_stubbed :anime }
    let!(:version_1) { create :version, user: user, item: anime, state: :taken }
    let!(:version_2) { create :version, user: user, item: anime, state: :accepted }
    let!(:version_3) { create :version, user: user, item: anime, state: :pending }
    let!(:version_4) { create :version, user: user, item: anime, state: :rejected }
    let!(:version_5) { create :version, user: user, item: anime, state: :deleted }
    let!(:version_6) { create :version, item: anime, state: :taken }
    subject { stats.versions_count }

    it { should eq 2 }
  end

  describe '#videos_changes_count' do
    let!(:report_1) { create :anime_video_report, user: user, state: 'accepted' }
    let!(:report_2) { create :anime_video_report, user: user, state: 'rejected' }
    let!(:report_3) { create :anime_video_report, state: 'accepted' }
    subject { stats.videos_changes_count }

    it { should eq 1 }
  end

end
