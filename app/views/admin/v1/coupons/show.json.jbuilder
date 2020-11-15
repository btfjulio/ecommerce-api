json.coupon do
  json.(@coupon, :id, *Coupon.list_params)
end