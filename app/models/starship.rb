class Starship
  attr_reader :name, :passengers, :cost_in_credits, :cargo_capacity, :movies

  def initialize(starship_hash)
    @name = starship_hash['name']
    @passengers = remove_comma(starship_hash['passengers'])
    @cost_in_credits = remove_comma(starship_hash['cost_in_credits'])
    @cargo_capacity = remove_comma(starship_hash['cargo_capacity'])
    @movies = starship_hash['movies']
  end

  def to_hash(type, metric)
    {
      name: name,
      passengers: passengers.to_i,
      cost_in_credits: cost_in_credits.to_i,
      cargo_capacity: cargo_capacity.to_i,
      movies: fetch_movies(type, metric)
    }
  end

  private

  def remove_comma(value)
    value.to_s.split(',').join
  end

  def fetch_movies(type, metric)
    redis = Redis.new

    return JSON.parse(redis.get("starships_#{type}_#{metric}_movies")) if redis.get("starships_#{type}_#{metric}_movies")

    titles = movies.map do |url|
      response = HTTParty.get(url, verify: false)

      if response.success?
        response.parsed_response['title']
      end
    end

    redis.set("starships_#{type}_#{metric}_movies", titles.to_json)

    titles
  rescue StandardError => e
    #Handle the error
  end
end