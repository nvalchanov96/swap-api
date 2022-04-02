class Analytics
  class << self
    def get_passengers_info(metric)
      new.passengers_info(metric)
    end

    def get_cost_in_credits_info(metric)
      new.cost_in_credits_info(metric)
    end

    def get_cargo_capacity_info(metric)
      new.cargo_capacity_info(metric)
    end

    def appeared_in_same_films_info(film_number)
      new.appeared_in_same_films(film_number)
    end
  end

  attr_reader :data

  def initialize
    @data = []
  end

  def passengers_info(metric)
    get_metric(metric)
    parsed_data = remove_strings(:passengers)
    total_count = data.size
    passengers_array = parse_to_int(parsed_data, :passengers)

    {
      average: Services::Operations.average(passengers_array, total_count),
      min: Services::Operations.min(passengers_array),
      max: Services::Operations.max(passengers_array),
      total_count: total_count,
      lowest: Services::Operations.lowest(parsed_data, :passengers).to_hash('lowest', 'passengers'),
      highest: Services::Operations.highest(parsed_data, :passengers).to_hash('highest', 'passengers')
    }
  end

  def cost_in_credits_info(metric)
    get_metric(metric)
    parsed_data = remove_strings(:cost_in_credits)
    total_count = data.size
    cost_in_credits_array = parse_to_int(parsed_data, :cost_in_credits)

    {
      average: Services::Operations.average(cost_in_credits_array, total_count),
      min: Services::Operations.min(cost_in_credits_array),
      max: Services::Operations.max(cost_in_credits_array),
      total_count: total_count,
      lowest: Services::Operations.lowest(parsed_data, :cost_in_credits).to_hash('lowest', 'cost_in_credits'),
      highest: Services::Operations.highest(parsed_data, :cost_in_credits).to_hash('highest', 'cost_in_credits')
    }
  end

  def cargo_capacity_info(metric)
    get_metric(metric)
    parsed_data = remove_strings(:cargo_capacity)
    total_count = data.size
    cargo_capacity_array = parse_to_int(parsed_data, :cargo_capacity)

    {
      average: Services::Operations.average(cargo_capacity_array, total_count),
      min: Services::Operations.min(cargo_capacity_array),
      max: Services::Operations.max(cargo_capacity_array),
      total_count: total_count,
      lowest: Services::Operations.lowest(parsed_data, :cargo_capacity).to_hash('lowest', 'cargo_capacity'),
      highest: Services::Operations.highest(parsed_data, :cargo_capacity).to_hash('highest', 'cargo_capacity')
    }
  end

  def appeared_in_same_films(film_number)
    get_metric('starships')
    get_metric('vehicles')

    metric_in_movie = data.select { |metric| metric.movies.any? { |movie| movie.split('/').last == film_number.to_s } }

    {
      starships: metric_in_movie.select { |metric| metric.is_a? Starship }.map(&:name),
      vehicles: metric_in_movie.select { |metric| metric.is_a? Vehicle }.map(&:name)
    }
  end

  private

  def remove_strings(field)
    data.select { |metric| metric.public_send(field).to_i.to_s == metric.public_send(field) }
  end

  def parse_to_int(parsed_data, field)
    parsed_data.map { |type| type.public_send(field).to_i }
  end

  def get_metric(metric)
    response_data = []
    redis = Redis.new

    return JSON.parse(redis.get(metric.pluralize)).map { |hash| data << metric.singularize.capitalize.constantize.new(hash) } if redis.get(metric.pluralize)

    Services::SwapApiRequest.fetch_data("#{metric.pluralize}", response_data)

    redis.set(metric.pluralize, response_data.to_json)

    response_data.each { |hash| data << metric.singularize.capitalize.constantize.new(hash) }
  end
end