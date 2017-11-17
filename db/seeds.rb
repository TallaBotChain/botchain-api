# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

u = User.new(email: 'botchain@talla.com', nickname: 'Bot', name: 'Bot Chain', password: "botchain")
u.skip_confirmation!
u.save!
