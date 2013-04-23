require 'webmock'
include WebMock::API

CSV_EXAMPLES = YAML.load_file(Rails.root.join('spec/fixtures/usgs_service/sample_csv_fragments.yml'))

FactoryGirl.define do
  factory :usgs_service, class: 'USGSService' do
    skip_create

    ignore do
      data_url 'http://example.com/data.csv'
      data CSV_EXAMPLES['sample_set']
    end

    initialize_with do
      stub_request(:get, data_url).to_return(body: data)
      new(data_url)
    end
  end
end
