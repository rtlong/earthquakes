require 'spec_helper'

shared_examples_for 'a JSON document' do
  it { raw_response.status.should be(200) }
  it { Oj.load(raw_response.body).should_not be_nil }
end

shared_examples_for 'a collection of earthquakes' do
  let(:properties) { parsed_response.map(&:keys).uniq }
  it { should have_at_least(1).items }
  it('is homogeneous') { properties.should have_at_most(1).set_of_properties }
  it('should only include the required properties') do
    properties.first.should =~ Earthquake::API_COLUMNS.map(&:to_s)
  end
end

shared_examples_for 'an empty collection' do
  it('should be an empty array') { parsed_response.should == [] }
end

def two_days_ago;
  2.days.ago;
end

def two_minutes_ago;
  2.minutes.ago;
end

describe "Earthquakes" do
  describe "GET /earthquakes.json" do

    let! :earthquakes do
      {
          normal: FactoryGirl.create(:earthquake),
          big: FactoryGirl.create(:earthquake, :big),
          two_days_ago: FactoryGirl.create(:earthquake, date_time: two_days_ago),
          two_minutes_ago: FactoryGirl.create(:earthquake, date_time: two_minutes_ago),
          nearby: FactoryGirl.create(:earthquake, latitude: 37.7804, longitude: -122.3943),
          nearby_but_too_far: FactoryGirl.create(:earthquake, latitude: 37.7554, longitude: -122.4528)
      }.tap { |e|
        e.each_key { |k| e[k] = e[k].source_id }
      }
    end

    let(:raw_response) {
      params = { format: :json }
      params.update(example.metadata[:params]) if example.metadata[:params]
      get earthquakes_path, params
      response
    }

    let(:parsed_response) { Oj.load(raw_response.body) }

    let(:response_eq_ids) { parsed_response.map { |e| e.values_at('source', 'eqid') } }

    subject { response_eq_ids }

    context 'with no params' do
      it_responds_with 'a JSON document'
      it_responds_with 'a collection of earthquakes'

      it 'returns all records' do
        should == earthquakes.values
      end
    end

    context '?since=__', params: { since: 30.minutes.ago.to_i } do
      let(:time) { Time.zone.at(example.metadata[:params][:since]) }
      it_responds_with 'a JSON document'
      it_responds_with 'a collection of earthquakes'

      it 'includes only those which occurred since time specified' do
        parsed_response.map { |e| e['date_time'] }.min.should be >= time
      end
      it('includes the example') { should include(earthquakes[:two_minutes_ago]) }

    end

    context '?on=__', params: { on: two_days_ago.to_i } do
      it_responds_with 'a JSON document'
      it_responds_with 'a collection of earthquakes'

      it 'includes only those which occurred on day specified' do
        parsed_response.map { |e| e['date_time'].to_date }.uniq.should == [two_days_ago.to_date]
      end
      it('includes the example') { should include(earthquakes[:two_days_ago]) }

    end

    context '?over=__', params: { over: 8.0 } do
      it_responds_with 'a JSON document'
      it_responds_with 'a collection of earthquakes'

      it 'includes only those with magnitude over given number' do
        parsed_response.map { |e| e['magnitude'] }.min.should(be > 8)
      end
      it('includes the example') { should include(earthquakes[:big]) }
    end

    context '?near=__', params: { near: '37.8266,-122.4224' } do
      let(:target) { example.metadata[:params][:near].split(?,).map(&:to_f) }
      it_responds_with 'a JSON document'
      it_responds_with 'a collection of earthquakes'

      it 'includes only those which occurred within a 5-mile radius of lat/lon provided' do
        parsed_response.map { |e|
          e = e.values_at('latitude', 'longitude')
          # for simplicity, just ask postgres to verify the distance for us:
          sql = 'SELECT earth_distance(ll_to_earth(%f,%f), ll_to_earth(%f,%f))' % [*e, *target]
          Earthquake.connection.select_value(sql).to_f
        }.max.should be < 8047 # 5mi =~ 8046.72m
      end

      it('includes the example') { should include(earthquakes[:nearby]) }
    end

    context '?since=__&on=__' do
      context 'with reasonable values', params: { since: 30.minutes.ago.to_i, on: Time.zone.now.beginning_of_day.to_i } do
        let(:time) { Time.zone.at(example.metadata[:params][:since]) }
        let(:date) { Time.zone.at(example.metadata[:params][:on]).to_date }
        it_responds_with 'a JSON document'
        it_responds_with 'a collection of earthquakes'

        it 'includes only those which occurred on day specified' do
          parsed_response.map { |e| e['date_time'].to_date }.uniq.should == [date]
        end

        it 'includes only those which occurred since time specified' do
          parsed_response.map { |e| e['date_time'] }.min.should be >= time
        end
        it('includes the example') { should include(earthquakes[:two_minutes_ago]) }
      end

      context 'with illogical values', params: { since: 1.day.ago.to_i, on: 3.days.ago.to_i } do
        it_responds_with 'a JSON document'
        it_responds_with 'an empty collection'
      end
    end


  end
end
