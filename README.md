<p align="center">
  <img src="app/assets/images/marginalia-wordmark.svg" alt="Marginalia" width="360">
</p>

<p align="center">
  <em>Your reading life, self-hosted.</em>
</p>

<p align="center">
  <a href="https://github.com/your-org/marginalia/actions/workflows/ci.yml">
    <img src="https://github.com/your-org/marginalia/actions/workflows/ci.yml/badge.svg" alt="CI">
  </a>
  <img src="https://img.shields.io/badge/Ruby-3.4-CC342D?logo=ruby&logoColor=white" alt="Ruby 3.4">
  <img src="https://img.shields.io/badge/Rails-8.1-CC0000?logo=rubyonrails&logoColor=white" alt="Rails 8.1">
  <img src="https://img.shields.io/badge/license-TBD-lightgrey" alt="License: TBD">
</p>

---

**Marginalia** is a personal book tracker and reading journal — a self-hosted alternative
to Goodreads, in the spirit of [Radarr][radarr] and [Sonarr][sonarr]. Track what you've
read, what you're reading, and what's next; rate and review; organize shelves; and keep
notes in the margins — all on hardware you control.

> [!NOTE]
> Marginalia is under active development and not yet feature-complete. Expect rough
> edges and breaking changes until a tagged release.

## Why self-hosted?

Your reading history is one of the most personal datasets you have. On a hosted service,
it belongs to the company — to be mined, sold, used to train recommendation engines, or
shut off whenever the business model changes. Goodreads is owned by Amazon, retired its
public API, and has been on life support for years. The data you put in is hard to get
back out.

Marginalia flips that:

- **You own your data.** Everything lives in a database on your server. Back it up, move
  it, query it, or export it — it's yours, in formats you control.
- **No tracking, no ads, no lock-in.** Nobody is profiling your reading to sell you
  things.
- **It keeps working.** No API to be deprecated, no service to be sunset. Your library
  runs as long as your server does.
- **Migrate in, migrate out.** Import your existing Goodreads CSV export on day one, and
  export your data any time you like.

## Features

- 📚 **Library management** — catalog your books with covers, metadata, and editions
- 🔖 **Shelves & status** — want-to-read, reading, and read, plus custom shelves
- ⭐ **Ratings & reviews** — rate, review, and keep private notes
- 📈 **Reading activity** — track progress, finish dates, and reading history
- 🔌 **Metadata providers** — pull book data from open sources (e.g. Open Library)
- 📥 **Goodreads import** — bring your existing library in via CSV export
- 🧙 **First-run setup wizard** — guided configuration on first launch
- 🔐 **Single-tenant, account-gated** — built for you (and optionally your household)

## Screenshots

> 📸 Screenshots coming soon.

<!--
<p align="center">
  <img src="docs/screenshots/library.png" alt="Library view" width="49%">
  <img src="docs/screenshots/book.png" alt="Book detail" width="49%">
</p>
-->

## Tech stack

- **Ruby** 3.4 / **Rails** 8.1
- **SQLite** for storage (zero external services to run)
- **Solid Queue / Solid Cache / Solid Cable** for jobs, caching, and websockets
- **Propshaft** + **Importmap** + **Tailwind CSS** for the asset pipeline
- **Hotwire** (Turbo + Stimulus) and **ViewComponent** for the UI
- **Puma** + **Thruster**

## Quick start

### With Docker (recommended)

> Distribution images are not published yet — see [Distribution](#distribution) below.
> For now, run from source.

### From source

Requirements: Ruby 3.4.7 and a C toolchain (for native gems).

```bash
git clone https://github.com/your-org/marginalia.git
cd marginalia

bin/setup          # installs dependencies and prepares the database
bin/dev            # starts the app (Rails, Tailwind watcher, jobs) on http://localhost:3000
```

On first launch, open the app in your browser and follow the **setup wizard** to create
your admin account, choose where your data lives, pick a metadata provider, and
(optionally) import an existing Goodreads CSV export.

## Configuration

Marginalia is configured in layers so operator concerns and user preferences stay
separate:

| Layer            | What it covers                                | Where it's set                 |
| ---------------- | --------------------------------------------- | ------------------------------ |
| **Environment**  | data directory, port, log level, secrets      | environment variables          |
| **App settings** | metadata provider, library paths, preferences | the setup wizard / settings UI |
| **Credentials**  | third-party API tokens                        | settings UI (stored encrypted) |

Common environment variables:

| Variable              | Description                                                 | Default   |
| --------------------- | ----------------------------------------------------------- | --------- |
| `MARGINALIA_DATA_DIR` | Directory for the database and uploaded files               | `/config` |
| `PORT`                | HTTP port to bind                                           | `3000`    |
| `RAILS_LOG_LEVEL`     | Log verbosity                                               | `info`    |
| `SECRET_KEY_BASE`     | Session signing key (auto-generated and persisted if unset) | —         |

## Development

```bash
bin/dev                 # run the app with live-reloading assets and jobs
bin/rails console       # interactive console
bin/rubocop             # lint
bin/brakeman            # static security analysis
```

### Running the tests

Marginalia uses Minitest (with Capybara + Selenium for system tests).

```bash
bin/rails test          # unit and integration tests
bin/rails test:system   # browser-driven system tests
```

## Distribution

> 🚧 **Work in progress.** Published images and finalized deploy docs are still on the way.
> The `docker-compose.yml` below is the intended shape of a production deploy.

### Docker Compose

```yaml
services:
  marginalia:
    image: ghcr.io/your-org/marginalia:latest
    container_name: marginalia
    restart: unless-stopped
    ports:
      - '3000:3000'
    environment:
      # Where the SQLite database and uploaded files live (mapped to the volume below).
      MARGINALIA_DATA_DIR: /config
      # Generate one with: openssl rand -hex 64
      # If omitted, Marginalia generates and persists a key in MARGINALIA_DATA_DIR.
      SECRET_KEY_BASE: ${SECRET_KEY_BASE}
      RAILS_LOG_LEVEL: info
    volumes:
      - marginalia_data:/config
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:3000/up']
      interval: 30s
      timeout: 5s
      retries: 3

volumes:
  marginalia_data:
```

```bash
# Put SECRET_KEY_BASE in a .env file next to the compose file, then:
docker compose up -d

# Open http://localhost:3000 and complete the setup wizard.
```

All persistent state lives in the `marginalia_data` volume (`/config` inside the
container). **Back that one volume up and your entire library is safe** — database,
covers, and uploads included.

### Deploying with Kamal

Marginalia ships with a [Kamal](https://kamal-deploy.org) configuration (`config/deploy.yml`).
Point it at your server and registry, then:

```bash
bin/kamal setup     # first deploy
bin/kamal deploy    # subsequent deploys
```

### Roadmap for this section

- [ ] Published multi-arch images (`ghcr.io/brandoncordell/marginalia`)
- [ ] Tagged releases and versioning policy
- [ ] Reverse-proxy / TLS examples (Caddy, Traefik, Cloudflare Tunnel)
- [ ] Backup & restore guide
- [ ] Upgrade and migration notes

## Contributing

Contributions are welcome. Please open an issue to discuss substantial changes before
submitting a pull request, and make sure `bin/rubocop` and the test suite pass.

## License

_TBD._

[radarr]: https://radarr.video/
[sonarr]: https://sonarr.tv/
