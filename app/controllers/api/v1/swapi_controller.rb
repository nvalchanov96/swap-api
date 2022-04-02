class Api::V1::SwapiController < ApplicationController
  before_action :check_query_param, except: [:appeared_in_same_films]

  ALLOWED_METRIC_QUERY_PARAMS = ['starship', 'starships', 'vehicle', 'vehicles'].freeze

  def passengers
    result = Analytics.get_passengers_info(request.parameters["metric"])

    render json: result.to_json, status: 200
  end

  def cost_in_credits
    result = Analytics.get_cost_in_credits_info(request.parameters["metric"])

    render json: result.to_json, status: 200
  end

  def cargo_capacity
    result = Analytics.get_cargo_capacity_info(request.parameters["metric"])

    render json: result.to_json, status: 200
  end
  
  def appeared_in_same_films
    unless request.parameters["film_number"] && request.parameters["film_number"].to_i.is_a?(Numeric)
      render json: { error: "Film number param should be a number" }, status: 400
    end

    result = Analytics.appeared_in_same_films_info(request.parameters["film_number"])

    render json: result.to_json, status: 200
  end

  private

  def check_query_param
    unless request.parameters["metric"] && ALLOWED_METRIC_QUERY_PARAMS.include?(request.parameters["metric"])
      render json: { error: "Metric param should be one of the following: #{ALLOWED_METRIC_QUERY_PARAMS}" }, status: 400
    end
  end
end
