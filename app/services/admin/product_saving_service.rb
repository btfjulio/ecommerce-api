module Admin
  class ProductSavingService
    class NotSavedProductError < StandardError; end

    attr_reader :product, :errors

    def initialize(params, product = nil)
      params = params.deep_symbolize_keys
      @product_params = params.reject { |key| key == :productable_attributes }
      @productable_params = params[:productable_attributes]
      @errors = {}
      @product = product || Product.new
    end

    def call
      Product.transaction do 
        @product.attributes = @product_params.reject { |key| key == :productable }
        build_productable
        ensure
          save!
        end
      end
    end

    def build_productable
      productable_class = @product_params[:productable].camelcase.safe_constantize
      @product.productable ||= productable_class.new
      @product.productable.attributes = @productable_params
    end

    def save!
      save_record!(@product.productable) if @product.productable.present?
      save_record!(@product)
    end

    def saved_record!(record)
      record.save!
    rescue ActiveRecord::RecordInvalid
      @errors.merge!(record.errors.messages)
    end

  end
end