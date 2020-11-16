require 'rails_helper'

shared_examples "unanthenticated requests" do |factory_name|
  context "GET /#{factory_name}s" do
    let(:url) { "/admin/v1/#{factory_name}s" }
    let!(:records) { create_list(factory_name, 5) }

    before(:each) { get url }

    include_examples "unauthenticated access"
  end

  context "POST /#{factory_name}s" do
    let(:url) { "/admin/v1/#{factory_name}s" }

    before(:each) { post url }
    include_examples "unauthenticated access"
  end
  
  context "PATCH /#{factory_name}s/:id" do
    let(:record) { create(factory_name) }
    let(:url) { "/admin/v1/#{factory_name}s/#{record.id}" }

    before(:each) { patch url }
    include_examples "unauthenticated access"
  end
 
  context "DELETE /#{factory_name}s/:id" do
    let(:record) { create(factory_name) }
    let(:url) { "/admin/v1/#{factory_name}s/#{record.id}" }

    before(:each) { delete url }
    include_examples "unauthenticated access"
  end
end