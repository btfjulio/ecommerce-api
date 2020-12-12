require 'rails_helper'

RSpec.describe "Admin::V1::Licenses as admin", type: :request do
  let(:user) { create(:user) }

  context "GET /licenses" do    
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) { create_list(:license, 5) }

    it "returns all licenses" do
      get(url, headers: auth_header(user))
      expected = licenses.as_json(only: [:id, *License.list_params])
      expect(body_json['licenses']).to eq(expected)
    end

    it "returns success status" do
      get(url, headers: auth_header(user))
      expect(response.status).to eq(200)
    end
  end


  context "POST /licenses" do
    let(:url) { "/admin/v1/licenses" }

    context "with valid params" do
      let(:game) { create(:game) }

      let(:license_params) do 
        { license: attributes_for(:license).merge(game_id: game.id) }.to_json
      end

      it "add a new license" do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License, :count).by(1)
      end

      it "returns last added license" do
        expect do
          post url, headers: auth_header(user), params: license_params
          expected = License.last.as_json(only: [:id, *License.list_params])
          puts License.last                                                    
          expect(body_json['license']).to eq(expected)
        end
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end

    end

    context "with invalid params" do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: nil) }.to_json
      end

      it "does not add a new license" do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to_not change(License, :count)
      end

      it "returns error messages" do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("key")
      end

      it "returns unprocessable_entity staus" do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  context "PATCH /licenses" do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1//licenses/#{license.id}"}

    context "with valid params" do
      let(:new_key) { Faker::Alphanumeric.alphanumeric(number: 20) }
      let(:license_params) { { license: { key: new_key } }.to_json }

      it "updates license" do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.key).to eq(new_key) 
      end

      it "returns updated license" do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expected = license.as_json(only: [:id, *License.list_params])
                                              
        expect(body_json["license"]).to eq(expected) 
      end
    end

    context "with invalid params" do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: nil) }.to_json
      end
      
      it 'does not update license' do
        old_key = license.key
        patch url, headers: auth_header(user), params: license_invalid_params 
        license.reload
        expect(license.key).to eq(old_key)  
      end

      it "returns error messages" do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("key")
      end

      it "returns unprocessable_entity staus" do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /licenses" do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}"}

    it "removes license" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(License, :count).by(-1)
    end

    it "returns success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it "does not return any body content" do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end

  end

  it_behaves_like "unanthenticated requests", :license
  it_behaves_like "client requests", :license
  
end