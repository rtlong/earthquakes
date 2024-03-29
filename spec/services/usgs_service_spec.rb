require 'spec_helper'

CSV_EXAMPLES = YAML.load_file(Rails.root.join('spec/fixtures/usgs_service/sample_csv_fragments.yml'))


describe USGSService do
  let(:service) { FactoryGirl.build :usgs_service }
  subject { service }

  context 'class-level interface' do
    subject { USGSService }
    describe '.latest' do
      it 'instantiates a new USGSService with the 7-day URL' do
        subject.should_receive(:new).with(USGSService::EQS7DAY)
        subject.latest
      end
    end
    describe '.new' do
      it 'returns new instance, given valid URI as parameter' do
        subject.new('uri://resource').should be_a(USGSService)
      end
      it 'raises an error given wrong number of params' do
        expect { subject.new() }.to raise_exception
        expect { subject.new('uri://resource', true) }.to raise_exception
      end
      it 'raises an error given bad URI' do
        expect { subject.new('bad uri') }.to raise_exception
      end
    end
  end


  describe '#data_url' do
    subject { USGSService.new 'uri://example' }

    it 'should be a URI parsed from the value given at initialization' do
      subject.data_url.should == URI.parse('uri://example')
    end
  end

  describe '#convert_row' do
    subject do
      data = CSV_EXAMPLES['sample_parsed_row_data'] || raise
      sample_row = CSV::Row.new(data.keys, data.values)
      service.convert_row(sample_row)
    end

    its([:source]) { should == 'ci' }
    its([:eqid]) { should == '12321' }
    its([:version]) { should == 1 }
    its([:date_time]) { should == DateTime.new(2013, 4, 19, 06, 47, 12) }
    its([:latitude]) { should == 39.8283 }
    its([:longitude]) { should == -122.8617 }
    its([:depth]) { should == 3.4 }
    its([:nst]) { should == 7 }
    its([:region]) { should == 'Northern California' }
  end

  describe '#all' do
    subject { service.all }
    it { should be_a_kind_of(Enumerable) }
    it { should have_exactly(3).items }
  end

  describe '#each' do
    it { subject.each.should be_an(Enumerator) }
    it 'should accept a block and pass to it the records' do
      values = []
      subject.each { |r| values << r }
      values.should == subject.all
    end
  end

  describe '#csv' do
    subject { service.csv }
    it { should respond_to(:each) }
    it('should invoke #data') do
      service.should_receive(:csv)
      subject
    end

    describe 'each item' do
      subject { service.csv.first }
      it { should be_a CSV::Row }
      it 'should respond to [] with symbolized header names' do
        subject[:src].should == 'ci'
      end
    end
  end

  describe '#data' do
    it 'returns the body of the response from GET-ing #data_url' do
      subject.data.should == CSV_EXAMPLES['sample_set']
    end
  end
end
