require 'spec_helper'

describe Earthquake do
  let(:earthquake) { FactoryGirl.build(:earthquake) }
  subject { earthquake }

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



end
