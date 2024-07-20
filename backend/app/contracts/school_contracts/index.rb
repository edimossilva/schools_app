# frozen_string_literal: true

module SchoolContracts
  class Index < ApplicationContract
    params do
      required(:school_name_like).filled(:string)
      required(:page).filled(:integer)
      required(:per_page).filled(:integer)
    end
  end
end
