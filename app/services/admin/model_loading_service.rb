module Admin  
  class ModelLoadingService
    def initialize(model, params)
      @searchable_model = model
      @params = params || {}
    end

    def call
      @searchable_model.search_by_name(@params.dig(:search, :name))
                        .order(@params[:order].to_h)
                        .paginate(
                          @params[:page].to_i, 
                          @params[:length].to_i
                        )
    end
  end
end