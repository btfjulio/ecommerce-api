module ListParams
  extend ActiveSupport::Concern

  included do
    scope :list_params, -> do
      columns.reduce([]) do |acc, column|
        ["id","created_at", "updated_at"].include?(column.name) ? acc : acc << column.name.to_sym
      end  
    end
  end
end