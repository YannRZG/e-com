Rails.application.config.after_initialize do
  if defined?(SolidCable::Record)
    SolidCable::Record.connects_to database: { writing: :primary_production, reading: :primary_production }
  end
end
