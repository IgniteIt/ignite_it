module ProjectsHelper
  def set_search_variable(params, sector_params)
    if params.nil? && sector_params.nil? && cant_get_location?
      @search = 'london'
    elsif params.nil?
      @search = request.location.city.downcase
      @sector = sector_params.downcase
    else
      @search = params.downcase
    end
  end

  def normal_query
    "lower(name) LIKE :search OR lower(address) LIKE :search"
  end

  def sector_query
    "lower(sector) LIKE :search"
  end

  def cant_get_location?
    request.location.city.length <= 0
  end

  def options_for_sector_search
    Project.uniq.pluck(:sector).unshift(['Search by sector', nil])
  end
end
