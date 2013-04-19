require 'spec_helper'

EXAMPLE_URL = 'http://example.com/earthquakes'

describe USGSService do
  let(:service){ USGSService.new(EXAMPLE_URL) }
  subject { service }

  context '.latest' do
    subject { USGSService }
    it 'instantiates a new USGSService with the 7-day URL' do
      subject.should_receive(:new).with(USGSService::EQS7DAY)
      subject.latest
    end
  end


  describe '#data_url' do
    subject { service.data_url }
    it 'should be a URI parsed from the value given at initialization' do
      should == URI.parse(EXAMPLE_URL)
    end
  end

  describe '#convert_row' do
    subject do
      service.convert_row src: 'test',
                          eqid: '12321',
                          version: '1',
                          datetime:"Friday, April 19, 2013 06:47:12 UTC",
                          lat:"39.8283",
                          lon:"-122.8617",
                          magnitude:"1.6",
                          depth:"3.40",
                          nst:" 7",
                          region:"Northern California"
    end
    its([:source]){ should == 'test' }
    its([:eqid]){ should == '12321' }
    its([:version]){ should == 1 }
    its([:date_time]){ should == DateTime.new(2013,4,19,06,47,12) }
    its([:latitude]){ should == 39.8283 }
    its([:longitude]){ should == -122.8617 }
    its([:depth]){ should == 3.4 }
    its([:nst]){ should == 7 }
    its([:region]){ should == 'Northern California' }
  end

  describe '#parse' do
    before do
      service.stub(:data) do
        "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\n"
        'ci,15329401,2,"Friday, April 19, 2013 07:16:30 UTC",32.8752,-116.2557,1.6,6.20,40,"Southern California"'
      end
    end

    subject { service.parse }
    it { should be_a_kind_of(Enumerable) }
  end

  describe '#csv' do
    subject { service.csv }
    before do
      service.stub(:data) { "test,CSV,data\n1,2,3" }
    end
    it { should respond_to(:each) }
    it('should invoke #data'){ service.should_receive(:data); subject }

    describe 'each item' do
      subject { service.csv.first }
      it { should be_a CSV::Row }
      it 'should respond to [] with symbolized header names' do
        subject[:csv] = '2'
      end
    end
  end

  describe '#data' do
    before do
      stub_request(:get, service.data_url.to_s).to_return(body: 'csv,data')
    end
    it 'returns the body of the response from GET-ing #data_url' do
      service.data.should == 'csv,data'
    end

  end
end
