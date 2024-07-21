# frozen_string_literal: true

class SyncSchoolsData < Actor
  input :schools_data_json
  input :school_index_contract_json
  output :data

  def call
    self.data = sync_schools_data
  end

  private

  def sync_schools_data
    SyncSchoolsOnDb.result(schools:, search_school_param:).data
  end

  def schools
    schools_data = JSON.parse(schools_data_json)
    schools_data.map { School.from_hash(_1) }
  end

  def search_school_param
    school_index_contract = JSON.parse(school_index_contract_json)
    SyncSearchSchoolParamOnDb.result(school_index_contract:).data
  end
end
