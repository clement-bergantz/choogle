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

1.upto(30) do |n|
    Choogle.create!(
      slug: SecureRandom.urlsafe_base64(5),
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

# Method to fill api_google_id of places table from google API
# Authenticate with google api key
# Query info from address and keep the first result
# Take .place_id method from google to fill our DB

def google_id(address)
  @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
  place_info = @client.spots_by_query(address)[0]
  place_info.nil? ? "not find" : place_info.place_id
end

1.upto(20) do |n|
  country = Faker::Address.country
    Place.create!(
      address: country,
      name: Faker::Company.name,
      api_google_id: google_id(country),
    )
end

puts "Proposals creation"

1.upto(120) do |n|
    Proposal.create!(
      choogle_id: Choogle.all.sample.id,
      place_id: Place.all.sample.id,
      user_id: User.all.sample.id,
    )
end

puts "Upvotes creation"

1.upto(150) do |n|

  upvotes = [Proposal.all.sample.id, User.all.sample.id]
  # To match the validation (uniqueness of user and proposal) before creating
  # an upvotes we check if .where return something, if not the values are good
  # if true new values are genereate and finally an upvote can be created.
  while Upvote.where(proposal_id: upvotes[0], user_id: upvotes[1]).size != 0
    upvotes = [Proposal.all.sample.id, User.all.sample.id]
  end

    Upvote.create!(
      proposal_id: upvotes[0],
      user_id: upvotes[1],
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

1.upto(100) do |n|
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
