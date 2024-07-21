# frozen_string_literal: true

class DestroyAll < Actor
  output :data

  def call
    self.data = [objects_summary]

    destroy_all
    destroy_all

    Rails.cache.clear

    data.push(objects_summary)
  end

  private

  def destroy_all
    School.with_deleted.destroy_all
    SchoolSearch.with_deleted.destroy_all
    SearchSchoolParam.with_deleted.destroy_all
  end

  def objects_summary
    {
      SearchSchoolParam: SearchSchoolParam.with_deleted.count,
      SchoolSearch: SchoolSearch.with_deleted.count,
      School: School.with_deleted.count
    }
  end
end
