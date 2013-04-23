require 'spec_helper'

shared_examples_for 'a JSON document' do
  it { raw_response.status.should be(200) }
  it { Oj.load(raw_response.body).should_not be_nil }
end

shared_examples_for 'a collection of earthquakes' do
  let(:properties) { parsed_response.map(&:keys).uniq }
  it('is homogeneous') { properties.count.should == 1 }
  it('should only include the required properties') do
    properties.first.sort.should == Earthquake::API_COLUMNS.map(&:to_s).sort
  end
end


describe "Earthquakes" do
  describe "GET /earthquakes.json" do
    let!(:earthquakes) { FactoryGirl.create_list(:earthquake, 3) }

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
      it_looks_like 'a JSON document'
      it_looks_like 'a collection of earthquakes'

      it 'returns all records' do
        should == earthquakes.map { |e| [e.source, e.eqid] }
      end
    end

    context '?since=__', params: { since: 30.minutes.ago.to_i } do
      it_looks_like 'a JSON document'
      it_looks_like 'a collection of earthquakes'

      it 'filters based on time since an earthquake' do
        pending
      end

    end


  end
end
