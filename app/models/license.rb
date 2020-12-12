class License < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :key, presence: true

  include Paginatable
  include Listable
end
