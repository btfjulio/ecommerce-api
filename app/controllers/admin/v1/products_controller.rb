module Admin::V1
  class ProductsController < ApiController
    before_action :set_product, only: %i[show update destroy]

    def index
      @loading_servce = Admin::ModelLoadingService.new(Product.all, searchable_params).call
    end

    def create
      run_service
    rescue Admin::ProductSavingService::NotSavedProductError
      render_error(fields: @saving_service.errors)
    end

    def show; end

    def update
      run_service
    rescue Admin::ProductSavingService::NotSavedProductError
      render_error(fields: @saving_service.errors)
    end

    def destroy
      @product.productable.destroy!
      @product.destroy!
    rescue ActiveRecord::RecordNotDestroyed
      render_error(
        fields: @product.errors.messages.merge(@product.productable.errors.messages)
      )
    end

    private

    def run_service(_product = nil)
      @saving_service = Admin::ProductSavingService.new(product_params.to_h, @product)
      @saving_service.call
      @product = @saving_service.product
      render :show
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      return {} unless params.has_key?(:product)

      permitted_params = params.require(:product).permit(
        :id, :name, :image, :price, :status,
        :description, :price, :productable, category_ids: []
      )
      permitted_params.merge(productable_params)
    end

    def productable_params
      productable_type = params[:product][:productable] || @product&.productable_type&.underscore
      return unless productable_type.present?
      productable_attributes = send("#{productable_type}_params")
      { productable_attributes: productable_attributes }
    end

    def game_params
      params.require(:product).permit(:mode, :release_date, :developer, :system_requirement_id)
    end

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def save_product!
      @product.save!
      render :show
    rescue StandardError
      render_error(fields: @product.errors.messages)
    end
  end
end
