require 'test_helper'

describe EPUBWriter do
  around do |test|
    Tempfile.create(['test', EPUBWriter::FILENAME_EXTENSION]) do |temp_file|
      @temp_file = temp_file
      test.call
    end
  end

  it 'writes a file' do
    EPUBWriter.new.write(@temp_file)
  end
end
