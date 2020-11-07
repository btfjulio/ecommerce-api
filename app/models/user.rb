# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates_presence_of :name, presence: true
  validates_presence_of :profile, presence: true

  enum profile: { admin: 0, client: 1 }
end
