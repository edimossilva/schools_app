# frozen_string_literal: true

class SyncSchoolsFromApiOrDb < Actor
  input :school_index_contract

  output :data

  def call
    self.data = sync_schools_from_api_or_db(school_index_contract)
  end

  private

  def sync_schools_from_api_or_db(school_index_contract)
    search_school_param = SyncSearchSchoolParamOnDb.result(school_index_contract:).data
    return search_school_param.schools if search_school_param.schools.any?

    schools = FetchSchools.result(school_index_contract:).data
    SyncSchoolsOnDb.result(schools:, search_school_param:).data
  end
end
