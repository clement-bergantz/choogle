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
  first_name: 'Lea'
  password: '123456',
  facebook_picture_url: "http://www.iconninja.com/files/632/403/650/princess-leia-icon.svg",
)
User.create!(
  email: 'romain@gmail.com',
  first_name: 'Romain'
  password: '123456',
  facebook_picture_url: "http://icon-icons.com/icons2/1070/PNG/512/luke-skywalker_icon-icons.com_76939.png",
)
User.create!(
  email: 'simon@gmail.com',
  first_name: 'Simon'
  password: '123456',
  facebook_picture_url: "http://icon-icons.com/icons2/1070/PNG/512/ewok_icon-icons.com_76943.png",
)
User.create!(
  email: 'clement@gmail.com',
  first_name: 'Clement'
  password: '123456',
  facebook_picture_url: "http://icon-icons.com/icons2/1070/PNG/512/yoda_icon-icons.com_76947.png",
)

puts "Choogles creation"

1.upto(30) do |n|
    Choogle.create!(
      slug: SecureRandom.urlsafe_base64(5),
      title: Faker::Superhero.name,
      due_at: "Mon, #{rand(1..15)} Oct 2017 21:20:44 UTC +00:00",
      happens_at: "Mon, #{rand(16..31)} Oct 2017 21:20:44 UTC +00:00",
      user: User.all.sample,
    )
end

puts "Comments creation"

1.upto(50) do |n|
    Comment.create!(
      content: Faker::Lorem.sentence,
      user: User.all.sample,
      choogle: Choogle.all.sample,
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

1.upto(15) do |n|
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
      choogle: Choogle.all.sample,
      place: Place.all.sample,
      user: User.all.sample,
    )
end

puts "Upvotes creation"

1.upto(150) do |n|

  upvotes = [Proposal.all.sample, User.all.sample]
  # To match the validation (uniqueness of user and proposal) before creating
  # an upvotes we check if .where return something, if not the values are good
  # if true new values are genereate and finally an upvote can be created.
  while Upvote.where(proposal: upvotes[0], user: upvotes[1]).size != 0
    upvotes = [Proposal.all.sample, User.all.sample]
  end

    Upvote.create!(
      proposal: upvotes[0],
      user: upvotes[1],
    )
end

puts "Notifications creation"

1.upto(50) do |n|
    Notification.create!(
      choogle: Choogle.all.sample,
      user: User.all.sample,
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
      proposal: Proposal.all.sample,
      tag: Tag.all.sample,
    )
end

puts "Well done myself ! - HAL"
