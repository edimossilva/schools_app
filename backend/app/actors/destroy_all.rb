# frozen_string_literal: true

class DestroyAll < Actor
  output :data

  def call
    self.data = [objects_summary]

    School.with_deleted.destroy_all
    SchoolSearch.with_deleted.destroy_all
    SearchSchoolParam.with_deleted.destroy_all
    School.with_deleted.destroy_all
    SchoolSearch.with_deleted.destroy_all
    SearchSchoolParam.with_deleted.destroy_all

    Rails.cache.clear

    data.push(objects_summary)
  end

  def objects_summary
    {
      SearchSchoolParam: SearchSchoolParam.with_deleted.count,
      SchoolSearch: SchoolSearch.with_deleted.count,
      School: School.with_deleted.count
    }
  end
end
