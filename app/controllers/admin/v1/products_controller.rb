module Admin::V1
  class ProductsController < ApiController
    before_action :set_product, only: %i[show update destroy]

    def index
      @products = set_products
    end

    def show; end

    def create
      @product = Product.new(product_params)
      save_product!
    end

    def update
      @product.attributes = product_params
      save_product!
    end

    def destroy
      @product.destroy!
    rescue StandardError
      render_error(fields: @product.errors.messages)
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      return {} unless params.has_key?(:product)

      params.require(:product).permit(
        :name, :image, :price, :status,
        :description, :price, :productable, category_ids: []
      )
    end

    def set_products
      permited_params = params.permit({ search: :name }, { order: {} }, :page, :length)
      Admin::ModelLoadingService.new(Product.all, permited_params).call
    end

    def save_product!
      @product.save!
      render :show
    rescue StandardError
      render_error(fields: @product.errors.messages)
    end
  end
end
