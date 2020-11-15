json.user do
  json.(@user, :id, *User.list_params)
end