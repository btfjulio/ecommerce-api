require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }

  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to define_enum_for(:status).with_values({ active: 1, inactive: 2}) }

  it { is_expected.to validate_presence_of(:due_date) }
  it { is_expected.to validate_presence_of(:discount_value) }
  it { is_expected.to validate_numericality_of(:discount_value).is_greater_than(0) }

  it "expected to validate that due_date cannot be before current date" do
    subject.due_date = 1.day.ago
    expect(subject.valid?).to eq(false) 
    expect(subject.errors.keys).to include(:due_date) 
  end

  it "expected to validate that due_date cannot be equal current date" do
    subject.due_date = Time.zone.now
    expect(subject.valid?).to eq(false) 
    expect(subject.errors.keys).to include(:due_date) 
  end

  it "expected to validate that due_date after current date" do
    subject.due_date = Time.zone.now
    expect(subject.errors.keys).not_to include(:due_date) 
  end

  it_behaves_like "paginatable concern", :coupon
end
