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

  it { should validate_presence_of :source }
  it { should ensure_length_of(:source).is_at_most(2) }
  it { should validate_presence_of :eqid }
  it { should validate_uniqueness_of(:eqid).scoped_to(:source) }
  it { should ensure_length_of(:eqid).is_at_most(30) }
  it { should validate_numericality_of :version }
  it { should validate_numericality_of :latitude }
  it { should validate_numericality_of :longitude }
  it { should validate_numericality_of :magnitude }
  it { should validate_numericality_of :depth }
  it { should validate_numericality_of :nst }

  #describe '.lt_version(Integer)' do
  #  it { Earthquake.should respond_to :lt_version }
  #  it 'limits to Earthquakes with version < parameter' do
  #    (1..5).each do |v|
  #      Earthquake.lt_version(v).where_values.grep(Arel::Nodes::LessThan).detect{|n| n.left.name == :version and n.right == v }.should_not be_nil
  #    end
  #  end
  #end
end
