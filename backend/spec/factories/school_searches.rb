# frozen_string_literal: true

# == Schema Information
#
# Table name: school_searches
#
#  id                     :bigint           not null, primary key
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  school_id              :bigint           not null
#  search_school_param_id :bigint           not null
#
# Indexes
#
#  index_school_searches_on_school_id               (school_id)
#  index_school_searches_on_search_school_param_id  (search_school_param_id)
#
# Foreign Keys
#
#  fk_rails_...  (school_id => schools.id)
#  fk_rails_...  (search_school_param_id => search_school_params.id)
#

FactoryBot.define do
  factory :school_search do
    search_school_param
    school
  end
end
