Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, constraints: { format: 'json' } do  
    namespace :v1 do  
      get 'passengers', to: 'swapi#passengers'
      get 'cost_in_credits', to: 'swapi#cost_in_credits'
      get 'cargo_capacity', to: 'swapi#cargo_capacity'
      get 'appeared_in_same_films', to: 'swapi#appeared_in_same_films'
    end  
  end  
end
