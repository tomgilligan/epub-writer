require 'test_helper'

describe EPUBWriter do
  it 'writes a file' do
    Tempfile.create(['test', EPUBWriter::FILENAME_EXTENSION]) do |temp_file|
      EPUBWriter.new.write(temp_file)
    end
  end
end
