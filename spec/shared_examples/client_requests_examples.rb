require "rails_helper"

shared_examples "client requests" do |factory_name|
  let(:user) { create(:user, profile: :client) }

  context "GET /#{factory_name}s" do
    let(:url) { "/admin/v1/#{factory_name}s" }
    let!(:records) { create_list(factory_name, 5) }

    before(:each) { get url, headers: auth_header(user)}

    include_examples "forbidden access"
  end

  context "POST /#{factory_name}s" do
    let(:url) { "/admin/v1/#{factory_name}s" }

    before(:each) { post url, headers: auth_header(user)}
    include_examples "forbidden access"
  end
  
  context "PATCH /#{factory_name}s/:id" do
    let(:record) { create(factory_name) }
    let(:url) { "/admin/v1/#{factory_name}s/#{record.id}" }

    before(:each) { patch url, headers: auth_header(user)}
    include_examples "forbidden access"
  end
 
  context "DELETE /#{factory_name}s/:id" do
    let(:record) { create(factory_name) }
    let(:url) { "/admin/v1/#{factory_name}s/#{record.id}" }

    before(:each) { delete url, headers: auth_header(user)}
    include_examples "forbidden access"
  end
end