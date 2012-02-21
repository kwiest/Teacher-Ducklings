FactoryGirl.define do
  factory :user do
    first_name 'Kyle'
    last_name 'Wiest'
    email 'kyle@example.com'
    password 'secret'
    password_confirmation 'secret'
    admin false
  end

  factory :admin, class: User do
    first_name 'Emma'
    last_name 'Martin'
    email 'emma@example.com'
    password 'secret'
    password_confirmation 'secret'
    admin true 
  end

  factory :category do
    name 'Math'
  end

  factory :post1, class: Post do
    title 'Test post 1'
    body 'Test post 1 body'
  end

  factory :post2, class: Post do
    title 'Test post 2'
    body 'Test post 2 body'
  end

  factory :link do
    name 'Tool'
    description 'A handy tool'
    url 'http://example.com/tool.pdf'
  end
end
