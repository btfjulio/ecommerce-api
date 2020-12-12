json.products do
  json.array! @loading_servce.records do |product|
    json.partial! product
    json.partial! product.productable
  end
end