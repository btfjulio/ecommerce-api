require 'rails_helper'

RSpec.describe "Admin::V1::Users as admin", type: :request do
  let!(:user) { create(:user) }

  context "GET /users" do    
    let(:url) { "/admin/v1/users" }
    let!(:users) { create_list(:user, 5 ) }

    it "returns all users" do
      get(url, headers: auth_header(user))
      expected = User.all.as_json(only: [:id, *User.list_params])
      expect(body_json['users']).to eq(expected)
    end

    it "returns success status" do
      get(url, headers: auth_header(user))
      expect(response.status).to eq(200)
    end
  end


  context "POST /users" do
    let(:url) { "/admin/v1/users" }

    context "with valid params" do
      let(:user_params) do 
        { user: attributes_for(:user) }.to_json
      end

      it "add a new user" do
        expect do
          post url, headers: auth_header(user), params: user_params
        end.to change(User, :count).by(1)
      end

      it "returns last added user" do
        expect do
          post url, headers: auth_header(user), params: user_params
          expected = user.last.as_json(only: [:id, *User.list_params])
          expect(body_json['user']).to eq(expected)
        end
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: user_params
        expect(response).to have_http_status(:ok)
      end

    end

    context "with invalid params" do
      let(:user_invalid_params) do
        { user: attributes_for(:user, name: nil) }.to_json
      end

      it "does not add a new user" do
        expect do
          post url, headers: auth_header(user), params: user_invalid_params
        end.to_not change(User, :count)
      end

      it "returns error messages" do
        post url, headers: auth_header(user), params: user_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("name")
      end

      it "returns unprocessable_entity staus" do
        post url, headers: auth_header(user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  context "PATCH /users" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}"}

    context "with valid params" do
      let(:new_name) { "My new user" }
      let(:user_params) { { user: { name: new_name } }.to_json }

      it "updates user" do
        patch url, headers: auth_header(user), params: user_params
        user.reload
        expect(user.name).to eq(new_name) 
      end

      it "returns updated user" do
        patch url, headers: auth_header(user), params: user_params
        user.reload
        expected = user.as_json(only: [:id, *User.list_params])
                                              
        expect(body_json["user"]).to eq(expected) 
      end
    end

    context "with invalid params" do
      let(:new_name) { "My new user" }
      let(:user_invalid_params) do 
        { user: attributes_for(:user, name: nil) }.to_json 
      end

      it 'does not update user' do
        old_name = user.name
        patch url, headers: auth_header(user), params: user_invalid_params 
        user.reload
        expect(user.name).to eq(old_name)  
      end

      it "returns error messages" do
        patch url, headers: auth_header(user), params: user_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("name")
      end

      it "returns unprocessable_entity staus" do
        patch url, headers: auth_header(user), params: user_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /users" do
    let!(:user_to_delete) { create(:user) }
    let(:url) { "/admin/v1/users/#{user_to_delete.id}"}

    it "removes user" do
      expect do
        delete url, headers: auth_header(user)
      end.to change(User, :count).by(-1)
    end

    it "returns success status" do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it "does not return any body contentx" do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end

  it_behaves_like "unanthenticated requests", :user
  it_behaves_like "client requests", :user

end