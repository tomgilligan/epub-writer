class EPUBWriter
  class Package
    def initialize(epub)
      @epub = epub
    end

    def to_xml
      doc = Nokogiri::XML::Builder.new({
        encoding: 'UTF-8'
      })

      doc.package({
        'xmlns' => 'http://www.idpf.org/2007/opf',
        'version' => '3.1',
        'xml:lang' => 'en',
        'unique-identifier' => 'pub-id',
        'prefix' => 'dc: http://purl.org/dc/elements/1.1/'
      }) do |package|
        package.metadata({
          'xmlns:dc' => 'http://purl.org/dc/elements/1.1/'
        }) do |metadata|
          %i(creator title language identifier publisher).each do |field|
            if @epub.send(field)
              metadata.send("dc:#{field}") do |field_element|
                field_element.text(@epub.send(field))
              end
            end
          end
        end

        package.manifest do |manifest|
          manifest.item({
            'href' => EPUBWriter::NCX_FILENAME,
            'media-type' => NCX::MIME_TYPE,
            'id' => NCX::ID
          })

          @epub.content_documents.each do |_, content_document_path, id|
            manifest.item({
              'href' => content_document_path,
              'media-type' => ContentDocument::MIME_TYPE,
              'id' => id
            })
          end
          # we want to be able to unique files that are referenced from content documents
        end

        package.spine do |spine|
          @epub.content_documents.each do |_, _, id|
            spine.itemref({
              'linear' => 'yes',
              'idref' => id
            })
          end
        end
      end
      doc.to_xml
    end
  end
end
