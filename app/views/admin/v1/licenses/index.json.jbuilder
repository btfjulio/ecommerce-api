json.licenses do
  json.array! @licenses, :id, *License.list_params
end