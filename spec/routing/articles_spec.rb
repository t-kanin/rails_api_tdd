require 'rails_helper'

#run only this file by -> rspec <routes> -> rspec spec/routing/articles_spec.rb

RSpec.describe '/articles' do 
  it 'routes to articles#index' do 
    #expect(get '/articles').to route_to(controller: 'articles', action:'index')
    #shorter version 
    aggregate_failures do  # to run more than one test even when the first test fail
      expect(get '/articles').to route_to('articles#index')
      expect(get '/articles?page[number]=3').to route_to('articles#index', page: {'number' => '3'})
    end
  end 

  it 'routes to article#show' do 
    expect(get 'articles/1').to route_to('articles#show', id: '1')
  end 
  
end 