class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :company, :stage, :created_at, :updated_at
end