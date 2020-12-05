require "rails_helper"

describe Admin::ModelLoadingService do
  context "when #call" do
    let!(:categories) { create_list(:category, 15) }
    
    context "when params are passed" do
      let!(:search_categories) do 
        categories = []
        15.times do |i| 
          categories << create(:category, name: "Search #{i}") 
        end 
        categories
      end

      let(:params) do
        { search: { name: "Search"}, order: { name: :desc }, page: 2, length: 4 }
      end

      it "should return the right number of categories" do
        service = described_class.new(Category.all, params)
        result = service.call
        expect(result.count).to eq 4
      end

      it "should return following search, order and pagination" do
        search_categories.sort! { |a, b| b.name <=> a.name }
        service = described_class.new(Category.all, params)
        result_categories = service.call
        expected_categories = search_categories[4..7]
        expect(result_categories).to contain_exactly(*expected_categories)
      end
    end

    context "when params are not passed" do
      it "should return default number of categories" do
        service = described_class.new(Category.all, nil)
        result = service.call
        expect(result.count).to eq 10
      end

      it "should return following search, order and pagination" do
        service = described_class.new(Category.all, nil)
        result_categories = service.call
        expected_categories = categories[0..9]

        expect(result_categories).to contain_exactly(*expected_categories)
      end
    end
  end
end