require 'test_helper'

describe EPUBWriter do
  before do
    @epub_writer = EPUBWriter.new
  end

  describe 'writes a file' do
    around do |test|
      Tempfile.create(['test', EPUBWriter::FILENAME_EXTENSION]) do |temp_file|
        @temp_file = temp_file
        test.call
      end
    end

    before do
      @epub_writer.write(@temp_file)
      @temp_file.rewind
      @file_contents = @temp_file.read
    end

    it 'file exists' do
      assert File.exist?(@temp_file)
    end

    it 'file contents' do
      refute_empty @file_contents
    end
  end

  describe 'writes to string io' do
    before do
      @string_io = StringIO.new

      @epub_writer.write(@string_io)
      @string_io.rewind
      @file_contents = @string_io.read
    end

    it 'file contents' do
      refute_empty @file_contents
    end
  end
end
