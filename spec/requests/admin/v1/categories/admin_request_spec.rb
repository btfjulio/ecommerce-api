require 'rails_helper'

RSpec.describe "Admin::V1::Categories as admin", type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do    
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 10 ) }

    context "without any params" do 
      before { get url, headers: auth_header(user) }
      
      it "should return 10 categories" do
        expect(body_json['categories'].count).to eq 10
      end

      it "returns 10 first Categories" do
        expected_categories = categories[0..9].as_json(only: %i(id name))
        expect(body_json['categories']).to contain_exactly *expected_categories
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with search[name] param" do
      let!(:search_name_categories) do
        categories = [] 
        15.times { |n| categories << create(:category, name: "Search #{n + 1}") }
        categories 
      end

      let(:search_params) { { search: { name: "Search" } } }

      before { get url, headers: auth_header(user), params: search_params }

      it "returns only seached categories limited by default pagination" do
        expected_categories = search_name_categories[0..9].as_json(only: %i(id name))
        expect(body_json['categories']).to contain_exactly *expected_categories
      end

      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      before { get url, headers: auth_header(user), params: pagination_params }

      it "returns records sized by :length" do
        expect(body_json['categories'].count).to eq length
      end
      
      it "returns categories limited by pagination" do
        expected_categories = categories[5..9].as_json(only: %i(id name))
        expect(body_json['categories']).to contain_exactly *expected_categories
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with order params" do
      let(:order_params) { { order: { name: 'desc' } } }

      before { get url, headers: auth_header(user), params: order_params}

      it "returns ordered categories limited by default pagination" do
        categories.sort! { |a, b| b[:name] <=> a[:name]}
        expected_categories = categories[0..9].as_json(only: %i(id name))
        expect(body_json['categories']).to contain_exactly *expected_categories
      end
 
      it "returns success status" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "GET /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    before { get url, headers: auth_header(user)}

    it 'should return the right category' do
      expected = category.as_json(only: %i(id name))
      expect(body_json["category"]).to eq expected
    end

    it 'should return the right category' do
      expect(response).to have_http_status(:ok)
    end
  end
  

  context "POST /categories" do
    let(:url) { "/admin/v1/categories" }

    context "with valid params" do
      let(:category_params) { { category: attributes_for(:category)}.to_json }
      it "add a new Category" do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.to change(Category, :count).by(1)
      end

      it "returns last added Category" do
        expect do
          post url, headers: auth_header(user), params: category_params
          expected_category = Category.last.as_json(only: %i(id name))
          expect(body_json['category']).to eq(expected_category)
        end
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:category_invalid_params) do
        { category: attributes_for(:category, name: nil) }.to_json
      end

      it "does not add a new Category" do

        expect do
          post url, headers: auth_header(user), params: category_invalid_params
        end.to_not change(Category, :count)
      end

      it "returns error messages" do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("name")
      end

      it "returns unprocessable_entity staus" do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end


  context "PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1//categories/#{category.id}"}

    context "with valid params" do
      let(:new_name) { "My new Category" }
      let(:category_params) { { category: { name: new_name } }.to_json }

      it "updates category" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq(new_name) 
      end

      it "returns updated category" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expected = category.as_json(only: %i(id name))
        expect(body_json["category"]).to eq(expected) 
      end
    end

    context "with invalid params" do
      let(:new_name) { "My new Category"}
      let(:category_invalid_params) do 
        { category: attributes_for(:category, name: nil) }.to_json 
      end

      it 'does not update category' do
        old_name = category.name 
        puts category_invalid_params
        patch url, headers: auth_header(user), params: category_invalid_params 
        category.reload
        expect(category.name).to eq(old_name)  
      end

      it "returns error messages" do
        patch url, headers: auth_header(user), params: category_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("name")
      end

      it "returns unprocessable_entity staus" do
        patch url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}"}

    it "removes Category" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Category, :count).by(-1)
    end

    it "returns success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it "does not return any body contend" do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

    it "removes all associated product categories" do
      product_categories = create_list(:product_category, 3, category: category)
      delete url, headers: auth_header(user)
      expected_product_categories = ProductCategory.where(id: product_categories.map(&:id))
      expect(expected_product_categories).to eq([])
    end
  end

end
