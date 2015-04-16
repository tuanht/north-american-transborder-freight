class StateSerializer < ActiveModel::Serializer
  attributes :id, :country_id, :code, :name
end
