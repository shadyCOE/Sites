# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

puts "START SEEDING"

file_to_load  = Rails.root + 'db/seed/countries.yml'
countries_list   = YAML::load( File.open( file_to_load ) )

countries_list.each_pair do |key,country|
  s = Country.find_by_abbreviation(country['abbreviation'])
  unless s
    c = Country.create(country) unless s
    c.update_attribute(:active, true) if Country::ACTIVE_COUNTRY_IDS.include?(c.id)
  end
end


file_to_load  = Rails.root + 'db/seed/states.yml'
states_list   = YAML::load( File.open( file_to_load ) )


states_list.each_pair do |key,state|
  s = State.find_by_abbreviation_and_country_id(state['attributes']['abbreviation'], state['attributes']['country_id'])
  State.create(state['attributes']) unless s
end

roles = Role::ROLES
roles.each do |role|
  Role.find_or_create_by_name(role)
end

AddressType::NAMES.each do |address_type|
  AddressType.find_or_create_by_name(address_type)
end

PhoneType::NAMES.each do |phone_type|
  PhoneType.find_or_create_by_name(phone_type)
end

ItemType::NAMES.each do |item_type|
  ItemType.find_or_create_by_name(item_type)
end

DealType::TYPES.each do |dt|
  DealType.find_or_create_by_name(dt)
end

Account::TYPES.each_pair do |acc_type, value|
  acc = Account.find_by_name(acc_type)
  unless acc
    Account.create(:name => acc_type, :account_type => acc_type, :monthly_charge => value)
  end
end

ShippingRateType::TYPES.each do |rate_type|
  ShippingRateType.find_or_create_by_name(rate_type)
end

ShippingZone::LOCATIONS.each do |loc|
  ShippingZone.find_or_create_by_name(loc)
end

TransactionAccount::ACCOUNT_TYPES.each do |acc_type|
  TransactionAccount.find_or_create_by_name(acc_type)
end

ReturnReason::REASONS.each do |value|
  rr = ReturnReason.find_by_label(value)
  unless rr
    ReturnReason.create(:label => value, :description => value )
  end
end

ReturnCondition::CONDITIONS.each do |value|
  rc = ReturnCondition.find_by_label(value)
  unless rc
    ReturnCondition.create(:label => value, :description => value )
  end
end
letters = Newsletter.count

Newsletter::AUTOSUBSCRIBED.each do |name|
  unless Newsletter.where(:name => name).first
    Newsletter.create(:name => name, :autosubscribe => true)
  end
end

if letters == 0
  # Subscribe everyone the first time around
  newsletter_ids = Newsletter.pluck(:id)
  User.find_each do |u|
    u.newsletter_ids = newsletter_ids
    u.save
  end
end

Newsletter::MANUALLY_SUBSCRIBE.each do |name|
  unless Newsletter.where(:name => name).first
    Newsletter.create(:name => name, :autosubscribe => false)
  end
end

ReferralBonus::BONUSES.each do |referral_bonus_attributes|
  rb = ReferralBonus.find_by_name(referral_bonus_attributes[:name])
  unless rb
    ReferralBonus.create(referral_bonus_attributes)
  end
end

ReferralProgram::PROGRAMS.each do |referral_program_attributes|
  rp = ReferralProgram.find_by_name(referral_program_attributes[:name])
  unless rp
    ReferralProgram.create(referral_program_attributes)
  end
end