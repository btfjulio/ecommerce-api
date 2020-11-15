json.coupons do
  json.array! @coupons, :id, *Coupon.list_params
end