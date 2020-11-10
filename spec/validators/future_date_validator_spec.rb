require "rails_helper"

class Validatable
  include ActiveModel::Validations
  attr_accessor :date 
  validates :date, future_date: true
end

describe FutureDateValidator do
  subject { Validatable.new }

  context "when date is before current date" do
    before { subject.date = 1.day.ago }

    it "should be invalid" do
      expect(subject.valid?).to be_falsey
    end

    it "adds an error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)  
    end
  end


  context "when date is equal current date" do
    before { subject.date = Date.today }

    it "should be invalid" do
      expect(subject.valid?).to be_falsey
    end

    it "adds an error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)  
    end
  end

  
  context "when date is after current date" do
    before { subject.date = Time.zone.now + 1.day }

    it "should be invalid" do
      expect(subject.valid?).to be_truthy
    end

    it "adds an error on model" do
      expect(subject.valid?).to be(true)  
    end
  end
end