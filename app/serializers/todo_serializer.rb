class TodoSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attributes :title, :created_by, :items
  has_many :items
end
