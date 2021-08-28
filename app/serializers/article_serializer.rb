class ArticleSerializer
  include JSONAPI::Serializer
  #set_type :articles -> to override the json data type
  attributes :title, :content, :slug
end
