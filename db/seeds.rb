# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

if ! Rails.env.production? && ! Rails.env.test?

  if User.count == 0
    user = User.new(email: 'botchain@talla.com', nickname: 'Bot', name: 'Bot Chain', password: "botchain")
    user.skip_confirmation!
    user.save!

    org = Organization.create!(name: "Hollywood", description: "Bots galore!")
    org.bots.create!(name: "Bender", description: "beep boop")
    org.bots.create!(name: "Robby", description: "beep boop")

    OrganizationMember.create!(organization: org, user: user)
  end

end
