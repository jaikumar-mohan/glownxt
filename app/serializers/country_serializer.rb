class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :phone_prefix
end
