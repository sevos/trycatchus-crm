FactoryGirl.define do
  sequence(:name) { |n| "Name #{n}"}
  sequence(:email) { |n| "email#{n}@example.com"}

  factory :contact do
    name
    phone "+491111222333"
    website_url "http://example.com"
    email
    association(:owner, factory: :user)
    description nil
  end

end
