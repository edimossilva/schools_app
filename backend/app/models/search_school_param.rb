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
class SearchSchoolParam < ApplicationRecord
  has_many :school_searches, dependent: :destroy
  has_many :schools, through: :school_searches

  validates :params, presence: true
  validates :params_as_key, presence: true, uniqueness: true
end
