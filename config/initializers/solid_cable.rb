# config/initializers/solid_cable.rb
Rails.application.config.after_initialize do
  if defined?(SolidCable::Record)
    SolidCable::Record.connects_to database: { writing: :production }
  end
end
