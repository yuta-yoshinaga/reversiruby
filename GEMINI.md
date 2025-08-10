# GEMINI.md

This file provides guidance to GEMINI when working with code in this repository.

## Project Overview

This is a standard Ruby on Rails application named `reversiruby`. It follows the Model-View-Controller (MVC) architectural pattern. The application appears to be a web-based version of the game Reversi.

## Common Commands

### Setup

To set up the development environment, run the following commands:

```bash
# Install gem dependencies
bundle install

# Set up the database
rails db:migrate
```

### Development Server

To run the local development server (defaults to `http://localhost:3000`):

```bash
rails server
```

### Testing

The application uses the built-in Minitest framework.

```bash
# Run all tests
rails test

# Run a single test file
rails test test/controllers/reversi_controller_test.rb
```

## Architecture

*   **Framework:** Standard Ruby on Rails.
*   **Frontend Assets:** The application uses the Rails Asset Pipeline (Sprockets) to manage CSS and JavaScript. The manifest files are `app/assets/stylesheets/application.css` and `app/assets/javascripts/application.js`. Key frontend libraries include `turbolinks` and `rails-ujs`.
*   **Configuration:** Configuration is environment-specific, located in `config/environments/`. The production environment (`config/environments/production.rb`) is configured to load the `SECRET_KEY_BASE` from an environment variable, as defined in `config/secrets.yml`.
*   **Database:** The database schema is managed by Active Record and defined in `db/schema.rb`. It includes a `sessions` table, indicating the application uses database-backed sessions.
*   **CI/CD:** The repository uses GitHub Actions for continuous integration. The `.github/workflows/codeql-analysis.yml` workflow is configured to perform CodeQL security analysis on the `javascript` code in the repository. Note that it is not currently configured to analyze Ruby code.