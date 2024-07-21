# frozen_string_literal: true

class SyncSchools < Actor
  input :school_index_contract
  output :data

  def call
    self.data = sync_schools
  end

  private

  def sync_schools
    schools = Rails.cache.fetch(search_school_param.params_as_key)
    schools ||= search_school_param.schools
    return schools if schools.any?

    result = FetchSchools.result(school_index_contract:)

    SyncSchoolsJob.perform_async(result.schools_data.to_json, school_index_contract.to_json)

    result.data
  end

  def search_school_param
    @search_school_param ||= SyncSearchSchoolParamOnDb.result(school_index_contract:).data
  end
end
