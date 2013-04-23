require 'spec_helper'

describe Earthquake do
  let(:earthquake) { FactoryGirl.build(:earthquake) }
  subject { earthquake }

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

  #describe '.lt_version(Integer)' do
  #  it { Earthquake.should respond_to :lt_version }
  #  it 'limits to Earthquakes with version < parameter' do
  #    (1..5).each do |v|
  #      Earthquake.lt_version(v).where_values.grep(Arel::Nodes::LessThan).detect{|n| n.left.name == :version and n.right == v }.should_not be_nil
  #    end
  #  end
  #end

  describe '.minimal' do
    it { Earthquake.should respond_to :minimal }
    it 'should select only the required columns for dump' do
      Earthquake.minimal.select_values.sort.should == Earthquake::API_COLUMNS.sort
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

end
