FactoryBot.define do
  factory :user do
    user_type { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
  end
end
