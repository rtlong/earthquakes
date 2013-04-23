require 'spec_helper'

describe EarthquakesImporter do
  let(:usgs_service) { FactoryGirl.build(:usgs_service) }
  subject { EarthquakesImporter.new(usgs_service) }

  describe 'class-level interface' do
    subject { EarthquakesImporter }
    describe '.new' do
      it { subject.new(usgs_service).should be_an_instance_of(EarthquakesImporter) }
    end
  end

  describe '#import_all' do
    it { should respond_to :import_all }
    it 'should call #each on the USGSService' do
      usgs_service.should_receive(:each)
      subject.import_all
    end
    it 'should create a new Earthquake for each record from the service' do
      subject.import_all
      Earthquake.all.to_a.should have(3).earthquakes
    end
    it 'should update Earthquakes where one already exists with the same source/eqid and version is greater' do
      FactoryGirl.create(:earthquake, source: 'ak', eqid: '10691420', version: 0)
      subject.import_all
      Earthquake.all.to_a.should have_exactly(3).earthquakes
      matching = Earthquake.where(source: 'ak', eqid: '10691420')
      matching.should have_exactly(1).earthquake
      matching.first.version.should == 3
    end
    it 'should skip Earthquakes where one already exists with a lower or equal version' do
      FactoryGirl.create(:earthquake, source: 'ak', eqid: '10691420', version: 3, region: 'blah')
      subject.import_all
      Earthquake.all.to_a.should have_exactly(3).earthquakes
      matching = Earthquake.where(source: 'ak', eqid: '10691420')
      matching.should have_exactly(1).earthquake
      matching.first.region.should == 'blah'
    end
  end

end
