# frozen_string_literal: true

class DestroyAll < Actor
  output :data

  def call
    SearchSchoolParam.with_deleted.destroy_all
    SchoolSearch.with_deleted.destroy_all
    School.with_deleted.destroy_all
    Rails.cache.clear

    self.data = {
      SearchSchoolParam: SearchSchoolParam.with_deleted.count,
      SchoolSearch: SchoolSearch.with_deleted.count,
      School: School.with_deleted.count
    }
  end
end
