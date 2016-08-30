require 'minitest/autorun'
require 'minitest/around/spec'
require 'tempfile'
require 'epub-writer'

# load whatever helpful tools you happen to have available in system gems
# no biggie if a tool isn't there.  we don't need to make these dev dependencies
begin
  require 'pry'
rescue LoadError
end
