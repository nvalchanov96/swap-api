module Services
  module SwapApiRequest
    extend self

    BASE_URI = 'https://swapi.dev/api'.freeze

    def fetch_data(metric, data)
      get_all_pages(metric, data)
    end

    private

    def get_all_pages(type, response = {'next' => '?page=1'}, data)
      return data unless response['next']

      response = HTTParty.get("#{BASE_URI}/#{type}/#{response['next'].split('/').last}", verify: false)

      if response.success?
        parsed_response = response.parsed_response
        
        parsed_response['results'].each do |metric|
          data << {
            'name' => metric['name'],
            'passengers' => metric['passengers'], 
            'cost_in_credits' => metric['cost_in_credits'],
            'cargo_capacity' => metric['cargo_capacity'],
            'movies' => metric['films']
          }
        end

        get_all_pages(type, parsed_response, data)
      else
        []
      end
    rescue StandardError => e
      #Handle the error
    end
  end
end