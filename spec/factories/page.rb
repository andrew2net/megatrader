FactoryGirl.define do
  factory :home_page, class: :page do
    type_id 1
    title "Home"
    url ""
    text "Home page text"
    keywords 'home, page'
    description 'This is a home page'
    after(:build) do |page, evaluation|
      I18n.available_locales.each do |locale|
        page.attributes = evaluation.attributes.merge({locale: locale})
      end
    end
  end

  factory :article_page, class: :page do
    type_id 2
    title 'Article'
    url '5-torgovlja-spredom'
    text 'Article about issue'
    keywords 'article, issue'
    description 'Discuss the issue'
    after(:build) do |article, evaluation|
      I18n.available_locales.each do |locale|
        article.attributes = evaluation.attributes.merge({locale: locale})
      end
    end
  end

  factory :news_page, class: :page do
    type_id 3
    title "News"
    url "29-novost-10"
    text "New news"
    keywords 'new, news'
    description 'This is a news'
    after(:build) do |news, evaluation|
      I18n.available_locales.each do |locale|
        news.attributes = evaluation.attributes.merge({locale: locale})
      end
    end
  end

end
