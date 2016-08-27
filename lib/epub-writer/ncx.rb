class EPUBWriter
  class NCX
    MIME_TYPE = 'application/x-dtbncx+xml'
    ID = 'ncx'

    def initialize(epub)
      @epub = epub
    end

    def to_xml
      doc = Nokogiri::XML::Builder.new({
        encoding: 'UTF-8'
      })
      doc.ncx({
        'xmlns' => 'http://www.daisy.org/z3986/2005/ncx/',
        'version' => '2005-1',
        'xml:lang' => @epub.language
      }) do |ncx|
        ncx.head do |head|

        end

        # is this optional?
        if @epub.title
          ncx.docTitle do |docTitle|
            docTitle.text(@epub.title)
          end
        end

        if @epub.creator
          ncx.docAuthor do |docAuthor|
            docAuthor.text(@epub.creator)
          end
        end

        ncx.navMap do |navMap|
          # without dictating document structure how do we know what to show here?
        end
      end
      doc.to_xml
    end
  end
end
