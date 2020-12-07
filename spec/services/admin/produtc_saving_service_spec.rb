require 'rails_helper'

RSpec.describe Admin::ProductSavingService, type: :model do
  context "when #call" do 

    context "sending loaded product" do 
      let!(:old_categories) { create_list(:category, 2) }
      let!(:new_categories) { create_list(:category, 2) }
      let!(:product) { create(:product, categories: old_categories) }

      context "with valid params" do 
        let!(:game) { product.productable }
        let(:params) do 
          { 
            name: "New product", 
            category_ids: new_categories.pluck(:id),
            productable_attributes: {
              developer: "New company"
            }
          } 
        end

        before do
          service = described_class.new(params, product)
          service.call
          product.reload
        end
        
        it "updates product" do
          expect(game.productable).to eq "New company"
        end

        it "updates :productable"
          expect(game.developer).to eq "New company"
        end
      
        it "updates :productable" do
          expect(product.categories.ids).to contain_exactly *new_categories.map(&:id)
        end
      end
  
      context "with invalid params" do 
      end
    end
  end
end