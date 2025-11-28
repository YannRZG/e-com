# config/initializers/solid_cable.rb
SolidCable::Record.connects_to database: { writing: :production }
