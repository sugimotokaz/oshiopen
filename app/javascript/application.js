// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import "trix"
import "@rails/actiontext"

import "./trix-editor-overrides"

import Rails from '@rails/ujs';
Rails.start();
