class DemoController < ApplicationController
  def index
  end

  def combo_async_options
    filtered_companies = get_companies
      .then do |companies|
        if params[:q].present?
          companies.select do |c|
            c[:name].downcase.include?(params[:q].downcase)
          end
        else
          companies
        end
      end
      .take(50)
      .map { |c| [ c.name, c.id ] }

    render turbo_stream:
             helpers.async_combobox_options(
               filtered_companies,
               include_blank: "Cancel selection"
             )
  end

  # This would be an API call in a real scenario
  def get_companies
    company = Data.define(:id, :name)

    (1..100).map { |i| company.new(id: i, name: "Company #{i}") }
  end
end
