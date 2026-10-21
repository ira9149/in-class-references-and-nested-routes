# Run with: bin/rails runner -e test test/verify_assignment.rb
abort "Run this verification in the test environment" unless Rails.env.test?

checks = 0
verify = lambda do |condition, message|
  raise message unless condition
  checks += 1
end
models = [Festival, Stage, Artist, Track, Attendee, Ticket, Performance]

ActiveRecord::Base.transaction do
  festival = Festival.create!(name: "Test Fest", starts_on: Date.new(2026, 10, 24), city: "Austin")
  stage = festival.stages.create!(name: "Main", capacity: 5000)
  artist = Artist.create!(name: "Test Band", genre: "Rock")
  track = artist.tracks.create!(title: "Test Song", length_sec: 180)
  attendee = Attendee.create!(name: "Test Guest", email: "guest@example.com")
  ticket = attendee.tickets.create!(festival: festival, tier: "General", price_cents: 7500)
  performance = stage.performances.create!(artist: artist, starts_at: Time.utc(2026, 10, 24, 23))

  verify.call(stage.festival == festival && festival.stages.include?(stage), "Festival/stage association failed")
  verify.call(track.artist == artist && artist.tracks.include?(track), "Artist/track association failed")
  verify.call(ticket.attendee == attendee && attendee.tickets.include?(ticket), "Attendee/ticket association failed")
  verify.call(ticket.festival == festival && festival.tickets.include?(ticket), "Festival/ticket association failed")
  verify.call(stage.artists.include?(artist) && artist.stages.include?(stage), "Through associations failed")
  encore = stage.performances.create!(artist: artist, starts_at: performance.starts_at + 1.hour)
  verify.call(encore.persisted?, "An artist must be able to perform on a stage more than once")

  models.each { |model| verify.call(!model.new.valid?, "#{model} accepts blank data") }
  verify.call(!stage.update(capacity: -1), "Negative stage capacity accepted")
  verify.call(!track.update(length_sec: 0), "Zero track length accepted")
  verify.call(!ticket.update(price_cents: -1), "Negative ticket price accepted")
  verify.call(!attendee.update(email: "invalid"), "Invalid email accepted")

  # update_all bypasses model validations, so these exercise database constraints.
  [[stage, :festival_id], [track, :artist_id], [ticket, :attendee_id],
   [ticket, :festival_id], [performance, :stage_id], [performance, :artist_id]].each do |record, key|
    begin
      record.class.where(id: record.id).update_all(key => -1)
      raise "Database accepted invalid #{record.class}.#{key}"
    rescue ActiveRecord::InvalidForeignKey
      checks += 1
    end
  end

  festival.destroy!
  verify.call(!Stage.exists?(stage.id), "Festival destruction left a stage")
  verify.call(!Ticket.exists?(ticket.id), "Festival destruction left a ticket")
  verify.call(!Performance.exists?(performance.id) && !Performance.exists?(encore.id), "Stage destruction left performances")
  verify.call(Artist.exists?(artist.id) && Attendee.exists?(attendee.id), "Festival destruction removed an independent parent")
  verify.call(Track.exists?(track.id), "Festival destruction removed an artist's track")

  other_festival = Festival.create!(name: "Other Fest", starts_on: Date.new(2026, 11, 1), city: "Boston")
  other_stage = other_festival.stages.create!(name: "Side", capacity: 100)
  other_performance = other_stage.performances.create!(artist: artist, starts_at: Time.utc(2026, 11, 1, 20))
  artist.destroy!
  verify.call(!Track.exists?(track.id) && !Performance.exists?(other_performance.id), "Artist destruction left children")
  verify.call(Stage.exists?(other_stage.id), "Artist destruction removed the stage")

  other_ticket = attendee.tickets.create!(festival: other_festival, tier: "Free", price_cents: 0)
  attendee.destroy!
  verify.call(!Ticket.exists?(other_ticket.id) && Festival.exists?(other_festival.id), "Attendee destruction failed")

  seed_counts = nil
  2.times do |run|
    load Rails.root.join("db/seeds.rb")
    counts = models.map(&:count)
    if run.zero?
      seed_counts = counts
    else
      verify.call(counts == seed_counts, "Seeds created duplicates on the second run")
    end
  end

  # Check route shapes and verbs without requiring controllers (optional in this assignment).
  routes = Rails.application.routes.routes
  [["/festivals/:festival_id/stages(.:format)", "stages"],
   ["/artists/:artist_id/tracks(.:format)", "tracks"],
   ["/attendees/:attendee_id/tickets(.:format)", "tickets"],
   ["/festivals/:festival_id/tickets(.:format)", "tickets"],
   ["/stages/:stage_id/performances(.:format)", "performances"],
   ["/artists/:artist_id/performances(.:format)", "performances"]].each do |path, controller|
    verify.call(routes.any? { |r| r.verb == "GET" && r.path.spec.to_s == path && r.defaults[:controller] == controller && r.defaults[:action] == "index" }, "Missing GET index route: #{path}")
  end
  verify.call(routes.any? { |r| r.verb == "GET" && r.path.spec.to_s == "/tracks/:id(.:format)" }, "Missing shallow track route")
  verify.call(routes.none? { |r| r.path.spec.to_s == "/artists/:artist_id/tracks/:id(.:format)" }, "Track member routes are still nested")

  raise ActiveRecord::Rollback
end
puts "#{checks} behavior checks passed (test data rolled back)."
