module Admin::V1
  class CategoriesController < ApiController
    before_action :set_category, only: %i[show update destroy]

    def index
      @categories = set_categories
    end

    def show
    end

    def create
      @category = Category.new(category_params)
      save_category!
    end

    def update
      @category.attributes = category_params
      save_category!
    end

    def destroy
      @category.destroy!
    rescue StandardError
      render_error(fields: @category.errors.messages)
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      return {} unless params.has_key?(:category)

      params.require(:category).permit(:name)
    end

    def set_categories
      permited_params = params.permit({ search: :name }, { order: {} }, :page, :length)
      Admin::ModelLoadingService.new(Category.all, permited_params).call
    end

    def save_category!
      @category.save!
      render :show
    rescue StandardError
      render_error(fields: @category.errors.messages)
    end
  end
end
