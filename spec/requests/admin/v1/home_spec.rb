require 'rails_helper'

describe "Home", type: :request do
  let(:user) { create(:user) }

  it "is expected to home request return correct body" do
    get('/admin/v1/home', headers: auth_header)
    expect(body_json).to eq({"message" => "Uhul!"})
  end


  it "is expected to home request return correct status" do
    get('/admin/v1/home', headers: auth_header)
    expect(response.status).to eq(200)
  end
end