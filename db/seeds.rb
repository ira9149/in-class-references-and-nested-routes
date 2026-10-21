# Repeatable sample data: running db:seed again reuses these records.
ActiveRecord::Base.transaction do
  festival = Festival.find_or_create_by!(name: "Sunset Fest", starts_on: Date.new(2026, 10, 24), city: "Austin")
  stage = festival.stages.find_or_create_by!(name: "Main Stage", capacity: 5000)
  festival.stages.find_or_create_by!(name: "Acoustic Stage", capacity: 800)

  artist = Artist.find_or_create_by!(name: "The Evening Lights", genre: "Indie rock")
  artist.tracks.find_or_create_by!(title: "Golden Hour", length_sec: 240)
  artist.tracks.find_or_create_by!(title: "Afterglow", length_sec: 195)

  attendee = Attendee.find_or_create_by!(name: "Jordan Lee", email: "jordan@example.com")
  attendee.tickets.find_or_create_by!(festival: festival, tier: "General admission", price_cents: 7500)
  Performance.find_or_create_by!(stage: stage, artist: artist, starts_at: Time.utc(2026, 10, 24, 23, 0))
end
