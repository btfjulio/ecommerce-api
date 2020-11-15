json.system_requirement do
  json.(@system_requirement, :id, *SystemRequirement.list_params)
end