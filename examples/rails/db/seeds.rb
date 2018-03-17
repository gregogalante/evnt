# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

producers = []

10.times do |index|
  p = Producer.create(
    uuid: SecureRandom.uuid,
    name: "Producer #{index + 1}"
  )
  producers.push(p.uuid)
end

20.times do |index|
  Product.create(
    uuid: SecureRandom.uuid,
    producer_uuid: producers.sample,
    name: "Product #{index + 1}",
    quantity_free: (1..100).to_a.sample,
    quantity_sold: (1..25).to_a.sample,
    price_per_piece: (10..50).to_a.sample
  )
end
