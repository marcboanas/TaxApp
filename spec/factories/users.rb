# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  first_name         :string
#  last_name          :string
#  email              :string
#  password_hash      :string
#  password_salt      :string
#  email_verification :boolean
#  verification_code  :string
#  api_authtoken      :string
#  authtoken_expiry   :datetime
#  provider           :string
#  uid                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  reset_sent_at      :datetime
#  reset_digest       :string
#  activated_at       :datetime
#  activated          :boolean
#  admin              :boolean
#  activation_digest  :string
#  remember_digest    :string
#

FactoryGirl.define do
  factory :user do
    first_name "MyString"
last_name "MyString"
email "MyString"
password_hash "MyString"
password_salt "MyString"
email_verification false
verification_code "MyString"
api_authtoken "MyString"
authtoken_expiry "2015-05-06 13:45:12"
provider "MyString"
uid "MyString"
  end

end
