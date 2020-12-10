module Admin::V1
  class LicensesController < ApplicationController
    before_action :set_license, only: %i(update destroy)

    def index 
      @licenses = License.all
    end

    def create 
      @license = License.new(license_params)
      save_license!
    end

    def update 
      @license.attributes = license_params
      save_license!
    end

    def destroy 
      @license.destroy!
    rescue => e
      render_error(fields: @license.errors.messages)
    end

    private

    def set_license
      @license = License.find(params[:id])
    end

    def license_params 
      return {} unless params.has_key?(:license)
      params.require(:license).permit(License.list_params)
    end

    def save_license!
      @license.save!
      render :show
    rescue
      render_error(fields: @license.errors.messages)
    end
  end
end
