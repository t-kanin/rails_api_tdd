require 'rails_helper'

# "rspec" runs all tests add  "--format=documentation" 
RSpec.describe Article, type: :model do
  #pending means the test is not yet finish , not executed
  #pending "add some examples to (or delete) #{__FILE__}"
  # naming convention '.' with class and '#' for instance object
  describe '#validations' do 
    let(:article) {build(:article)}

    it "is valid " do
      #FactoryBot.create the factorybot can be ommitted due to the config we changed in rails_helper  
      expect(article).to be_valid # equal to article/valid? == true
    end

    it "has an invalid title" do 
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end 

    it "has an invalid content" do 
      article.content = '' 
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end 
    
    it "has an invalid slug" do 
      article.slug = ''
      expect(article).not_to be_valid 
      expect(article.errors[:slug]).to include("can't be blank")
    end 

    it "validate uniqueness of the slug" do 
      article1 = create(:article)
      expect(article1).to be_valid
      article2 = build(:article, slug: article1.slug)
      expect(article2).not_to be_valid
      expect(article2.errors[:slug]).to include("has already been taken")
    end 

  end 

  describe ".recent" do 
    it 'return articles in correct order' do 
      older_article = create(:article,slug: "some-article", created_at: 1.hour.ago)
      recent_article = create(:article)

      expect(described_class.recent).to eq(
        [recent_article, older_article]
      )

      #make sure that the test use created_at column to sort  by chaning the recent created_at to 2 hour ago
      recent_article.update_column(:created_at, 2.hour.ago)
      expect(described_class.recent).to eq([older_article, recent_article]) 
    end 
  end 
end
