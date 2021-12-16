require 'codebreaker_gem'
require 'i18n'
require 'terminal-table'
require_relative 'view'
require_relative 'controller'
I18n.load_path << Dir[['config', 'locales', '**', '*.yml'].join('/')]
I18n.config.available_locales = :en
