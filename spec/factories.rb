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
end
