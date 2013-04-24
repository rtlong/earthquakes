require 'spec_helper'

describe Earthquake do

  describe 'the Factory' do
    subject { FactoryGirl.build(:earthquake) }
    it 'should generate a valid record' do
      subject.should be_valid
    end
  end

  describe 'validations' do
    let(:existing) { FactoryGirl.create(:earthquake) }

    it { should validate_presence_of :source }
    it { should ensure_length_of(:source).is_at_most(2) }
    it { should validate_presence_of :eqid }
    it { existing; should validate_uniqueness_of(:eqid).scoped_to(:source) }
    it { should ensure_length_of(:eqid).is_at_most(30) }
    it { should validate_numericality_of :version }
    it { should validate_numericality_of :latitude }
    it { should validate_numericality_of :longitude }
    it { should validate_numericality_of :magnitude }
    it { should validate_numericality_of :depth }
    it { should validate_numericality_of :nst }
  end

  describe 'default scope' do
    it 'should only show last 7 days data' do
      Earthquake.all.to_sql.should match(/date_time['"]? >= '?#{7.days.ago.to_date}/)
    end
  end

  describe '.magnitude_over(float)' do
    it 'should select only those with magnitude greater than given' do
      Earthquake.unscoped.magnitude_over(4.5).to_sql.should match(/magnitude['"]? > 4.5/)
    end
  end

  describe '.on_date(date)' do
    it 'should select only those where date_time lies within date given' do
      today = Date.today
      Earthquake.unscoped.on_date(today).to_sql.should match(/date\(.*date_time.*\) = '#{today.to_s(:db)}'/)
    end
  end

  describe '.since_time(date_time)' do
    it 'should select only those where date_time is after time given' do
      time = 2.hours.ago
      Earthquake.unscoped.since_time(time).to_sql.should match(/date_time['"]? > '?#{time.to_s(:db)}/)
    end
  end

  describe '.near(lat,long)' do
    it 'should select only those nearby the location specified' do
      lat, lng = 1, 2
      # N.B. I really don't know how to test these scopes...
      Earthquake.unscoped.near(lat, lng).to_sql.should match(/earth_distance\(ll_to_earth\(#{lat},\s*#{lng}\),\s*ll_to_earth\(latitude,\s*longitude\)\)\s*<\s*\d+/)
    end
  end

  describe '.stale' do
    subject{Earthquake.stale.to_sql}
    it 'should select only those where date_time is more than 7 days ago' do
      should match(/date_time['"]? < '?#{7.days.ago.to_date}/)
      should_not match(/date_time['"]? >= '?#{7.days.ago.to_date}/)
    end
  end

  describe '.minimal' do
    it { Earthquake.should respond_to :minimal }
    it 'should select only the required columns for dump' do
      Earthquake.minimal.select_values.should =~ Earthquake::API_COLUMNS
    end
  end

  describe '.for_json' do
    before do
      FactoryGirl.create_list(:earthquake, 3, source: 'us')
      FactoryGirl.create(:earthquake, source: 'ak')
    end
    it { Earthquake.for_json.should have_exactly(4).objects }
    it 'responds with an Array of Hashes' do
      ary = Earthquake.for_json
      ary.should be_an_instance_of(Array)
      ary.first.should be_an_instance_of(Hash)
    end
    it 'respects the AReL scope: select()' do
      Earthquake.select([:source, :nst]).for_json.first.keys.should == %w[source nst]
    end
    it 'respects the AReL scope: where()' do
      Earthquake.where(source: 'ak').for_json.should have_exactly(1).object
    end
    it 'correctly type-casts the values' do
      Earthquake.select([:source, :nst, :date_time, :magnitude]).for_json.first.values.map(&:class).should == [String, Fixnum, String, BigDecimal]
    end
  end

  describe '#source_id' do
    subject { Earthquake.new(source: 'ab', eqid: 'test') }
    its(:source_id) { should == [subject.source, subject.eqid] }
  end

end
