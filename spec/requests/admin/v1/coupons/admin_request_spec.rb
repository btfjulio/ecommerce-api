require 'rails_helper'

RSpec.describe "Admin::V1::Coupons as admin", type: :request do
  let(:user) { create(:user) }

  context "GET /coupons" do    
    let(:url) { "/admin/v1/coupons" }
    let!(:coupons) { create_list(:coupon, 5 ) }

    it "returns all coupons" do
      get(url, headers: auth_header(user))
      expected = coupons.as_json(only: [:id, *Coupon.list_params])
      expect(body_json['coupons']).to eq(expected)
    end

    it "returns success status" do
      get(url, headers: auth_header(user))
      expect(response.status).to eq(200)
    end
  end


  context "POST /coupons" do
    let(:url) { "/admin/v1/coupons" }

    context "with valid params" do
      let(:coupon_params) do 
        { coupon: attributes_for(:coupon) }.to_json
      end

      it "add a new coupon" do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      it "returns last added coupon" do
        expect do
          post url, headers: auth_header(user), params: coupon_params
          expected = Coupon.last.as_json(only: [:id, *Coupon.list_params])
          expect(body_json['coupon']).to eq(expected)
        end
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end

    end

    context "with invalid params" do
      let(:coupon_invalid_params) do
        { coupon: attributes_for(:coupon, code: nil) }.to_json
      end

      it "does not add a new coupon" do
        expect do
          post url, headers: auth_header(user), params: coupon_invalid_params
        end.to_not change(Coupon, :count)
      end

      it "returns error messages" do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("code")
      end

      it "returns unprocessable_entity staus" do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  context "PATCH /coupons" do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1//coupons/#{coupon.id}"}

    context "with valid params" do
      let(:new_code) { "My new coupon" }
      let(:coupon_params) { { coupon: { code: new_code } }.to_json }

      it "updates coupon" do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        expect(coupon.code).to eq(new_code) 
      end

      it "returns updated coupon" do
        patch url, headers: auth_header(user), params: coupon_params
        coupon.reload
        expected = coupon.as_json(only: [:id, *Coupon.list_params])
                                              
        expect(body_json["coupon"]).to eq(expected) 
      end
    end

    context "with invalid params" do
      let(:new_code) { "My new coupon" }
      let(:coupon_invalid_params) do 
        { coupon: attributes_for(:coupon, code: nil) }.to_json 
      end

      it 'does not update coupon' do
        old_code = coupon.code
        patch url, headers: auth_header(user), params: coupon_invalid_params 
        coupon.reload
        expect(coupon.code).to eq(old_code)  
      end

      it "returns error messages" do
        patch url, headers: auth_header(user), params: coupon_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("code")
      end

      it "returns unprocessable_entity staus" do
        patch url, headers: auth_header(user), params: coupon_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /coupons" do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}"}

    context "system requirement has no associated games" do

      it "removes coupon" do
        expect do
          delete url, headers: auth_header(user)
        end.to change(Coupon, :count).by(-1)
      end

      it "returns success status" do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end

      it "does not return any body contend" do
        delete url, headers: auth_header(user)
        expect(body_json).to_not be_present
      end
      
    end

  end

end