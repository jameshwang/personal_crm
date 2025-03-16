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

# Create test users
alice = User.create!(
  email: 'alice@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

bob = User.create!(
  email: 'bob@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create contacts for Alice
alice_contacts = [
  {
    first_name: 'John',
    last_name: 'Doe',
    email: 'john@example.com',
    phone: '1234567890',
    job_title: 'Software Engineer',
    company: 'Tech Corp',
    notes: 'Regular client meeting every month'
  },
  {
    first_name: 'Jane',
    last_name: 'Smith',
    email: 'jane@example.com',
    phone: '0987654321',
    job_title: 'Project Manager',
    company: 'Management Inc',
    notes: 'Prefers email communication'
  }
]

alice_contacts.each do |contact_data|
  contact = alice.contacts.create!(contact_data)
  
  # Create reminders for each contact
  alice.reminders.create!(
    title: "Follow up with #{contact.first_name}",
    description: "Quarterly check-in",
    date: Time.current + 1.week,
    status: 'pending',
    contact: contact
  )
  
  # Create interactions for each contact
  alice.interactions.create!(
    interaction_type: 'Meeting',
    notes: "Initial meeting with #{contact.first_name}",
    date: Time.current - 2.days,
    contact: contact
  )
end

# Create contacts for Bob
bob_contacts = [
  {
    first_name: 'Michael',
    last_name: 'Johnson',
    email: 'michael@example.com',
    phone: '5551234567',
    job_title: 'Marketing Director',
    company: 'Marketing Pro',
    notes: 'Potential partnership opportunity'
  },
  {
    first_name: 'Sarah',
    last_name: 'Williams',
    email: 'sarah@example.com',
    phone: '5559876543',
    job_title: 'CEO',
    company: 'Startup Inc',
    notes: 'Interested in our enterprise solution'
  }
]

bob_contacts.each do |contact_data|
  contact = bob.contacts.create!(contact_data)
  
  # Create reminders for each contact
  bob.reminders.create!(
    title: "Follow up with #{contact.first_name}",
    description: "Monthly check-in",
    date: Time.current + 3.days,
    status: 'pending',
    contact: contact
  )
  
  # Create interactions for each contact
  bob.interactions.create!(
    interaction_type: 'Call',
    notes: "Introduction call with #{contact.first_name}",
    date: Time.current - 1.week,
    contact: contact
  )
end

puts "Seed data created successfully!"
puts "Test users created:"
puts "1. Email: alice@example.com, Password: password123"
puts "2. Email: bob@example.com, Password: password123"
