Rails.application.routes.draw do
  # ---------- Pair A: Festival -> Stage ----------
  # List a festival's stages: GET /festivals/:festival_id/stages.
  # params[:festival_id] identifies the festival; params[:id] is a stage on member routes.
  resources :festivals do
    resources :stages
  end

  # ---------- Pair B: Artist -> Track (use shallow nesting) ----------
  # List an artist's tracks: GET /artists/:artist_id/tracks (params[:artist_id]).
  # Index and create stay nested because they need an artist context.
  # Show, update, and destroy use /tracks/:id:
  # the track's unique id already identifies its artist, so the parent id is redundant.
  # This API-only app omits the HTML form routes (new and edit).
  resources :artists do
    resources :tracks, shallow: true
  end

  # ---------- Pair C: Attendee -> Ticket (and Festival -> Ticket) ----------
  # GET /attendees/:attendee_id/tickets lists purchase history (params[:attendee_id]).
  # GET /festivals/:festival_id/tickets lists festival sales (params[:festival_id]).
  # Both views are useful because a ticket belongs to both an attendee and a festival.
  resources :attendees do
    resources :tickets
  end
  resources :festivals, only: [] do
    resources :tickets
  end

  # ---------- Integrator: Stage / Artist -> Performance ----------
  # List a stage's schedule: GET /stages/:stage_id/performances (params[:stage_id]).
  # List an artist's bookings: GET /artists/:artist_id/performances (params[:artist_id]).
  resources :stages, only: [] do
    resources :performances
  end
  resources :artists, only: [] do
    resources :performances
  end
end
