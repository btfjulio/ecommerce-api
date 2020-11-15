json.system_requirements do
  json.array! @system_requirements, :id, *SystemRequirement.list_params
end