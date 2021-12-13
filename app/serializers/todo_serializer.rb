class TodoSerializer
  include JSONAPI::Serializer

  attributes :title, :created_by
  has_many :item
end
