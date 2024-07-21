# frozen_string_literal: true

class SyncSchoolsJob
  include Sidekiq::Job

  def perform(schools_data_json, school_index_contract_json)
    schools_data = JSON.parse(schools_data_json)
    school_index_contract = JSON.parse(school_index_contract_json)
    search_school_param = SyncSearchSchoolParamOnDb.result(school_index_contract:).data
    schools = schools_data.map { School.from_hash(_1) }
    Rails.cache.fetch(school_index_contract.to_json) do
      SyncSchoolsOnDb.result(schools:, search_school_param:)
    end
  end
end
