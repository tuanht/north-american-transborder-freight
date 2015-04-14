class Mode < ActiveRecord::Base
  validates :code, uniqueness: true
end
