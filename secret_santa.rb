# frozen_string_literal: true

require 'aws-sdk-sns'

FILE_PATH = ARGV[0]
AWS_ACCESS_KEY_ID = ARGV[1]
AWS_SECRET_ACCESS_KEY = ARGV[2]
AWS_REGION = ARGV[3]

data = {}
people = []

File.readlines(FILE_PATH).shuffle.each do |line|
  name, phone_number = line.split(',')
  data[name] = phone_number.strip
  people << name
end

people << people.first
pairs = people.each_cons(2).to_a

sns = Aws::SNS::Client.new(
  access_key_id: AWS_ACCESS_KEY_ID,
  secret_access_key: AWS_SECRET_ACCESS_KEY,
  region: AWS_REGION
)

pairs.each do |(current_person, chosen_person)|
  message = "Você tirou #{chosen_person} no amigo secreto! O presente deve ser de até R$50,00"
  phone_number = data[current_person]
  response = sns.publish(phone_number: phone_number, message: message)
  puts response
  puts "#{current_person} -> #{chosen_person}"
end
