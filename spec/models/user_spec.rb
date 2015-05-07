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

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
