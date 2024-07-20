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
class SearchSchoolParam < ApplicationRecord
  has_many :school_searches, dependent: :destroy
  has_many :schools, through: :school_searches

  validates :params, presence: true
  validates :params_as_key, presence: true
end
