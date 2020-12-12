module Admin::V1
  class CouponsController < ApiController
    before_action :set_coupon, only: %i(show update destroy)

    def index 
      @coupons = Coupon.all
    end

    def show 
    end

    def create 
      @coupon = Coupon.new(coupon_params)
      save_coupon!
    end

    def update 
      @coupon.attributes = coupon_params
      save_coupon!
    end

    def destroy 
      @coupon.destroy!
    rescue => e

      render_error(fields: @coupon.errors.messages)
    end

    private

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params 
      return {} unless params.has_key?(:coupon)
      params.require(:coupon).permit(Coupon.list_params)
    end

    def save_coupon!
      @coupon.save!
      render :show
    rescue
      render_error(fields: @coupon.errors.messages)
    end

  end
end
