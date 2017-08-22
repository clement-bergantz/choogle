puts "Let's destroy all the tables datas."

ProposalTag.destroy_all
Tag.destroy_all
Notification.destroy_all
Upvote.destroy_all
Proposal.destroy_all
Place.destroy_all
Comment.destroy_all
Choogle.destroy_all
User.destroy_all


puts "Let's generate a lot of useless things..."
puts "Ok well... Choogle's team users creation"

User.create!(
  email: 'lea@gmail.com',
  password: '123456',
)
User.create!(
  email: 'romain@gmail.com',
  password: '123456',
)
User.create!(
  email: 'simon@gmail.com',
  password: '123456',
)
User.create!(
  email: 'clement@gmail.com',
  password: '123456',
)

puts "Choogles creation"

1.upto(35) do |n|
    Choogle.create!(
      slug: Faker::Number.number(10),
      title: Faker::Superhero.name,
      due_at: "Mon, #{rand(1..15)} Oct 2017 21:20:44 UTC +00:00",
      happens_at: "Mon, #{rand(16..31)} Oct 2017 21:20:44 UTC +00:00",
      user_id: User.all.sample.id,
    )
end

puts "Comments creation"

1.upto(50) do |n|
    Comment.create!(
      content: Faker::Lorem.sentence,
      user_id: User.all.sample.id,
      choogle_id: Choogle.all.sample.id,
    )
end

puts "Places creation"

def google_id(address)
  @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
  place_info = @client.spots_by_query(address)[0]
  api_google_id = place_info.place_id
end

1.upto(1) do |n|
  country = Faker::Address.country
    Place.create!(
      address: country,
      name: Faker::Company.name,
      api_google_id: google_id(country),
    )
end

puts "Proposals creation"

1.upto(140) do |n|
    Proposal.create!(
      choogle_id: Choogle.all.sample.id,
      place_id: Place.all.sample.id,
      user_id: User.all.sample.id,
    )
end

puts "Upvotes creation"

1.upto(200) do |n|
    Upvote.create!(
      proposal_id: Proposal.all.sample.id,
      user_id: User.all.sample.id,
    )
end

puts "Notifications creation"

1.upto(50) do |n|
    Notification.create!(
      choogle_id: Choogle.all.sample.id,
      user_id: User.all.sample.id,
    )
end

puts "Tags creation"

1.upto(30) do |n|
    Tag.create!(
      name: Faker::Lorem.word + Faker::Number.number(2),
      color: Faker::Color.hex_color,
    )
end

puts "Proposal_Tags creation"

1.upto(60) do |n|
    ProposalTag.create!(
      proposal_id: Proposal.all.sample.id,
      tag_id: Tag.all.sample.id,
    )
end

puts "Well done myself ! - HAL"
