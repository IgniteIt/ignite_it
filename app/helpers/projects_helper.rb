module ProjectsHelper
  def set_search_variable(params, sector_params)
    if params.nil? && sector_params.nil? && cant_get_location?
      @search = 'London'
    elsif params.nil?
      @search = request.location.city
      @sector = sector_params
    else
      @search = params
    end
  end

  def normal_query
    "name LIKE :search OR address LIKE :search"
  end

  def sector_query
    "sector LIKE :search"
  end

  def cant_get_location?
    request.location.city.length <= 0
  end

  def options_for_sector_search
    Project.uniq.pluck(:sector)
  end
end
