json.users do
  json.array! @users, :id, *User.list_params
end