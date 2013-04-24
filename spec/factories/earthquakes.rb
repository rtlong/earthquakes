# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :earthquake do
    source { (?a..?z).to_a.sample(2).join }
    eqid { [?0..?9, ?a..?z].map(&:to_a).flatten.sample(8+rand(8)).join }
    version { ((rand*(10**0.25)) ** 4).floor } # low-weighted random 0..10
    date_time { Time.at rand(7.days.ago.to_i..DateTime.now.to_i) }
    latitude { Faker::Geolocation.lat }
    longitude { Faker::Geolocation.lng }
    magnitude { (1 + (rand*(7**0.1))**10).round(1) } # low-weighted random 1..8
    depth { (rand * 600).round(1) }
    nst { rand(200) }
    region { |i| "region name #{i}" }

    trait :big do
      magnitude { (8.1 + rand * 2).round(1) }
    end
  end


end
