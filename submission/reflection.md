# Reflection answers

Team: Festival Schema Sprint (In-Class Activity #6)

Members (as listed in the assignment):

- Sanjan Gadde — sg8147@nyu.edu
- Isabel Ayres — ira9149@nyu.edu
- Alex Zhu — ayz2057@nyu.edu
- Oleksandra Kovalenko — ok2178@nyu.edu

**a. In each relationship, which table holds the foreign key, and why that table?**

`stages.festival_id` references `festivals.id`, and `tracks.artist_id` references `artists.id`. `tickets` holds both `attendee_id` and `festival_id`, while `performances` holds both `stage_id` and `artist_id`. These six foreign keys belong on the many side: each child row refers to one parent in each relationship, while a parent can have many child rows without storing a list of ids. For the many-to-many relationship, each performance connects one stage to one artist, and multiple performance rows allow both sides to have many partners.

The migrations create festivals before stages, artists before tracks, and attendees and festivals before tickets. Performances are created last, after both stages and artists exist. All references use `foreign_key: true` and `null: false`, so the database rejects missing or nonexistent parents.

**b. What happens to a Festival's Stages when the Festival is destroyed? Where in your code did you specify that behavior?**

Calling `festival.destroy!` destroys its stages because `app/models/festival.rb` declares `has_many :stages, dependent: :destroy`. Each stage also destroys its performances through `has_many :performances, dependent: :destroy` in `app/models/stage.rb`; the artists remain. The festival's tickets are destroyed through its separate `has_many :tickets, dependent: :destroy`, while attendees remain. This choice treats stages, bookings, and tickets as records owned by this practice festival; `:nullify` would leave invalid parentless children, and `:restrict_with_error` would prevent deleting a festival with children. In a production ticketing system, preserving purchase history could justify restricting deletion instead.

This is Active Record behavior: `delete` and direct SQL skip those callbacks. The database foreign keys still prevent orphan rows, but do not themselves specify cascading deletion. Artist-to-tracks, artist-to-performances, and attendee-to-tickets also use `dependent: :destroy` to remove owned children without deleting the other parent of a join record.

**c. Why does `Performance` need to be its own model with its own table, rather than a bare join table with no model?**

A performance represents a scheduled event, not just membership in a stage/artist pair: it has its own `starts_at` value, identity, timestamps, and presence validation. A stage and artist can be linked more than once at different times, so each occurrence needs its own record. The `Performance` model belongs to both parents and supports `Stage#artists` and `Artist#stages` through `has_many :through`; it can also be addressed by the nested performance routes and extended with event-specific rules.

**Bonus (Pair B): what changed in `rails routes` when you used `shallow: true`?**

Track collection routes remain under `/artists/:artist_id/tracks` for index and create. Member routes use `/tracks/:id` for show, update (PATCH or PUT), and destroy. This starter is API-only, so Rails omits the HTML form actions `new` and `edit`; there are no corresponding form routes in our listing. A collection needs an artist context, but an existing track's globally unique id already identifies its artist. `params[:artist_id]` supplies the parent on collection routes; `params[:id]` identifies a track on member routes.

**Bonus (Pair C): why might tickets be nested under both Attendee and Festival?**

`/attendees/:attendee_id/tickets` answers which tickets one attendee has purchased, so it fits purchase history. `/festivals/:festival_id/tickets` answers which tickets were sold for a festival, so it fits festival sales reporting. The same ticket has both foreign keys, making both contexts meaningful without duplicating the underlying record. The route parameter provides a context for filtering; a future controller would still need to scope queries and enforce authorization.
