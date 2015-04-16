class UsaState < ActiveRecord::Base
  validates :code, uniqueness: true, length: {maximum: 2}
end
