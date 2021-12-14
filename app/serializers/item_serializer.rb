class ItemSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :name, :done
  belongs_to :todo
end
