require 'rails_helper'

RSpec.describe ArticlesController do 

  before(:all) do
    Rails.cache.clear
  end

  describe '#index' do 
    it 'return success response' do 
      get '/articles' 
      expect(response).to have_http_status(:ok)
    end 
  end 

  it 'returns a proper JSON' do 
    article = create(:article)
    get '/articles'
    #body not needed because we refactor it to the api_helpers
    #body = JSON.parse(response.body).deep_psymbolize_keys # to chage it to symbol type :title instead of "title"
    # pp body to inspect the body in a more readable way use it before the expectation
    expect(json_data.length).to eq(1)
    expected = json_data.first
    aggregate_failures do 
      expect(expected[:id]).to eq(article.id.to_s)
      expect(expected[:type]).to eq('article')
      expect(expected[:attributes]).to eq(
        title: article.title,
        content: article.content,
        slug: article.slug
      )
    end 
  end 

  it 'return recent article articles' do 
    older_article = create(:article,slug: "some-article", created_at: 1.hour.ago)
    recent_article = create(:article)
    get '/articles' 
    ids = json_data.map {|item| item[:id].to_i}
    expect(ids).to eq([recent_article.id, older_article.id])
  end 

  it 'paginates result' do 
    article1, article2, article3 = create_list(:article,3)
    get '/articles', params: {page: {number: 2, size: 1}} # page1 = article1, page2 = article2
    expect(json_data.length).to eq(1)
    expect(json_data.first[:id]).to eq(article2.id.to_s)
  end 

  it 'contain pagination links' do 
    article1, article2, article3 = create_list(:article,3)
    get '/articles', params: {page: {number: 2, size: 1}} # page1 = article1, page2 = article2
    expect(json[:links].length).to eq(5)
    expect(json[:links].keys).to contain_exactly(:first,:prev,:next,:last,:self)
  end 

end 

