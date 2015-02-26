FactoryGirl.define do
  factory :note do
    contact
    association(:owner, factory: :user)
    title "MyString"
    description "MyText"
  end

end
