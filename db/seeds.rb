# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
puts "Clearing existing data..."
Contact.destroy_all
Tag.destroy_all

# Create tags
puts "Creating tags..."
tags = {
  client: Tag.create!(name: "Client"),
  prospect: Tag.create!(name: "Prospect"),
  vendor: Tag.create!(name: "Vendor"),
  partner: Tag.create!(name: "Partner"),
  vip: Tag.create!(name: "VIP"),
  tech: Tag.create!(name: "Tech"),
  finance: Tag.create!(name: "Finance"),
  marketing: Tag.create!(name: "Marketing")
}

# Create contacts
puts "Creating contacts..."
contacts = [
  {
    first_name: "Sarah",
    last_name: "Johnson",
    email: "sarah.johnson@techcorp.com",
    phone: "415-555-0123",
    company: "TechCorp",
    job_title: "CTO",
    notes: "Met at SF Tech Conference. Interested in AI solutions.",
    tags: [tags[:tech], tags[:vip]]
  },
  {
    first_name: "Michael",
    last_name: "Chen",
    email: "mchen@financeplus.com",
    phone: "212-555-0456",
    company: "Finance Plus",
    job_title: "Investment Director",
    notes: "Quarterly review scheduled. Potential for expanded partnership.",
    tags: [tags[:client], tags[:finance]]
  },
  {
    first_name: "Emily",
    last_name: "Rodriguez",
    email: "emily.r@marketpro.com",
    phone: "310-555-0789",
    company: "MarketPro",
    job_title: "Marketing Manager",
    notes: "Discussing Q3 campaign collaboration.",
    tags: [tags[:marketing], tags[:prospect]]
  },
  {
    first_name: "James",
    last_name: "Wilson",
    email: "jwilson@innovatech.com",
    phone: "650-555-0234",
    company: "InnovaTech",
    job_title: "CEO",
    notes: "Potential strategic partnership opportunity.",
    tags: [tags[:tech], tags[:vip], tags[:prospect]]
  },
  {
    first_name: "Lisa",
    last_name: "Thompson",
    email: "lisa.t@vendex.com",
    phone: "408-555-0567",
    company: "Vendex Solutions",
    job_title: "Sales Director",
    notes: "Current software vendor. Annual contract renewal in 3 months.",
    tags: [tags[:vendor], tags[:tech]]
  }
]

# Create contacts and their associations
contacts.each do |contact_data|
  tags = contact_data.delete(:tags)
  contact = Contact.create!(contact_data)
  tags.each { |tag| ContactTag.create!(contact: contact, tag: tag) }
end

# Create some interactions
puts "Creating interactions..."
Contact.all.each do |contact|
  # Create 2-3 interactions for each contact
  rand(2..3).times do
    days_ago = rand(1..30)
    interaction_types = ["Call", "Email", "Meeting", "Video Call"]
    
    Interaction.create!(
      contact: contact,
      date: days_ago.days.ago,
      interaction_type: interaction_types.sample,
      notes: ["Discussed project timeline", "Quarterly review", "Introduction call", "Follow-up meeting", "Contract negotiation"].sample
    )
  end
end

# Create some reminders
puts "Creating reminders..."
Contact.all.each do |contact|
  # Create 1-2 reminders for each contact
  rand(1..2).times do
    days_ahead = rand(1..30)
    
    Reminder.create!(
      contact: contact,
      date: days_ahead.days.from_now,
      title: ["Follow up", "Schedule meeting", "Send proposal", "Contract renewal", "Quarterly review"].sample,
      description: "Remember to follow up on previous discussion.",
      status: ["pending", "completed"].sample
    )
  end
end

puts "Seed data created successfully!"
