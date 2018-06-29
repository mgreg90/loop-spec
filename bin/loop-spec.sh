function install_bundler {
  echo "\033[0;32mYou don't have bundler???\nInstalling now...\033[0m" && gem install bundler
}

# Install bundler if they don't have it
bundle -v &> /dev/null || install_bundler

# Get ruby version
PLAYWRIGHT_LOOP_SPEC_RUBY_VERSION=$(ruby -ryaml -e " puts (YAML.load_file(\"#{ENV['HOME']}/.playwright/plays/loop-spec/config.yml\")[:ruby_version] || '').gsub('.', '')")

# command to run proper ruby version
PLAYWRIGHT_RUBY_COMMAND="$HOME/.playwright/rubies/ruby$PLAYWRIGHT_LOOP_SPEC_RUBY_VERSION"

# Remember current gem env vars
OLD_GEM_PATH=$GEM_PATH
OLD_GEM_HOME=$GEM_HOME

# Set gem home so that any new gems are installed to local folder
GEM_HOME="$HOME/.playwright/plays/loop-spec/gems"
# Set gem path to use gems from local folder, as well as normal paths
GEM_PATH="$GEM_HOME:$GEM_PATH"

# Run play
$PLAYWRIGHT_RUBY_COMMAND -W0 $HOME/.playwright/plays/loop-spec/loop-spec "$@"

# Set gem env vars back to previous values
GEM_HOME=$OLD_GEM_HOME
GEM_PATH=$OLD_GEM_PATH