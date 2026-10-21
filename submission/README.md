# In-Class Activity #6 submission

Completed implementation: seven hand-written migrations and models, six database foreign keys, validations, dependent destruction, and all required nested routes (including shallow track member routes).

## Deliverables

- `schema.rb`: generated schema, also available at `db/schema.rb`.
- `models.txt`: source listing of all seven domain models plus `ApplicationRecord`.
- `routes.txt`: Rails route header and routes matching `stages|tracks|performances|tickets`.
- `reflection.md`: all three required reflections and both bonus answers.
- `seeds.rb`: repeatable example data covering every table, copied from `db/seeds.rb`.

The completed assignment PDF in `docs/` is being handled separately by the team.

## Reproduce and verify

Run from the project root:

```bash
bin/setup
bin/rails db:seed
bin/rails festival:check
bin/rails runner -e test test/verify_assignment.rb
bin/deliverables
```

Verified locally: all seven migrations applied, 45/45 structural checks passed, and 40 behavior checks passed. Behavior verification covers associations, validations, all six database foreign keys, dependent destruction, repeatable seeds, and route shapes. It uses the test database and rolls back its sample data.

The app is API-only, so route listings omit HTML `new` and `edit` form routes. Controllers are not required for this activity.
