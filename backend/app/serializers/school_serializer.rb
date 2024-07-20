# frozen_string_literal: true

class SchoolSerializer < ActiveModel::Serializer
  attributes :id, :name, :external_id, :lat, :lng
end
