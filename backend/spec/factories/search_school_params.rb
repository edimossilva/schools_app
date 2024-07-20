# frozen_string_literal: true

# == Schema Information
#
# Table name: search_school_params
#
#  id            :bigint           not null, primary key
#  deleted_at    :datetime
#  params        :jsonb
#  params_as_key :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_search_school_params_on_params_as_key  (params_as_key) UNIQUE
#
FactoryBot.define do
  factory :search_school_param do
    params do
      {
        page: 0,
        per_page: 10,
        "school.name" => "nice name"
      }
    end
    params_as_key do
      {
        page: 0,
        per_page: 10,
        "school.name" => "nice name"
      }.to_s
    end
  end
end
