json.license do
  json.(@license, :id, *License.list_params)
end