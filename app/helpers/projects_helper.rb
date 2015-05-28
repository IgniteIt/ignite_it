module ProjectsHelper
  def set_search_variable(search, sector)
    if no_params(search, sector)
      @search = ''
      @sector = ''
    else
      @search = search.downcase if !search.nil?
      @sector = sector.downcase if !sector.nil?
    end
  end

  def get_location
    # @location = request.location.city
    @location = 'london' 
    # if empty?(request.location.city)
  end

  def get_coords
    # @coord = [request.location.latitude, request.location.longitude]
    @coord = [51.51, -0.07] 
    # if request.location.longitude == 0.0
  end

  def main_query
    "lower(name) LIKE :search OR lower(address) LIKE :search"
  end

  def search_query
    "(lower(name) LIKE :search OR lower(address) LIKE :search) AND lower(sector) LIKE :sector"
  end

  def empty?(params)
    params.length <= 0
  end

  def no_params(search, sector)
    (search.nil? || empty?(search)) && (sector.nil? || empty?(sector))
  end

  def options_for_sector_search
    Project.uniq.pluck(:sector).sort.unshift(['Search by sector', nil, disabled: true, selected: true])
  end
end
