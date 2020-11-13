shared_examples "forbidden access" do
  it "returns error message" do
    expoect(body_json['errors']['message']).to eq('Forbiden access')
  end

  it 'return forbidden status' do
    expect(response).to have_http_status(:forbidden)
  end
end