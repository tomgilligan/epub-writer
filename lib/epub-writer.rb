require 'nokogiri'
require 'zip'

require 'epub-writer/version'
require 'epub-writer/package'
require 'epub-writer/ncx'
require 'epub-writer/content_document'

class EPUBWriter
  CONTAINER_DIRECTORY = 'OEBPS'
  PACKAGE_FILENAME = 'content.opf'

  META_INF_DIRECTORY = 'META-INF'
  CONTAINER_FILENAME = 'container.xml'

  MIMETYPE_FILENAME = 'mimetype'
  MIMETYPE_FILE_CONTENTS = 'application/epub+zip'

  FILENAME_EXTENSION = 'epub'

  CONTENT_DOCUMENT_PREFIX = 'content_document'
  CONTENT_DOCUMENT_EXTENSION = 'xhtml'

  NCX_FILENAME = "toc.ncx"

  attr_reader :package, :content_documents
  attr_accessor :creator, :title, :identifier, :publisher
  attr_writer :language

  def initialize
    @content_documents = []
    @package = Package.new(self)
    @ncx = NCX.new(self)
  end

  def language
    @language || 'en'
  end

  # NB. we don't check to see if we colide with other files
  def self.content_document_path(index)
    "#{CONTENT_DOCUMENT_PREFIX}_#{index.to_s.rjust(4, '0')}.#{CONTENT_DOCUMENT_EXTENSION}"
  end

  def self.content_document_id(index)
    "#{CONTENT_DOCUMENT_PREFIX}_#{index.to_s.rjust(4, '0')}"
  end

  def add_content_document
    content_document = ContentDocument.new(self)
    @content_documents.push([
      content_document,
      self.class.content_document_path(@content_documents.length),
      self.class.content_document_id(@content_documents.length)
    ])
    content_document
  end

  def mimetype_file_path
    MIMETYPE_FILENAME
  end

  def mimetype_file_contents
    MIMETYPE_FILE_CONTENTS
  end

  def package_file_path
    "#{CONTAINER_DIRECTORY}/#{PACKAGE_FILENAME}"
  end

  def package_file_contents
    @package.to_xml
  end

  def container_file_path
    "#{META_INF_DIRECTORY}/#{CONTAINER_FILENAME}"
  end

  def container_file_contents
    doc = Nokogiri::XML::Builder.new({encoding: 'UTF-8'})
    doc.container({
      version: '1.0',
      xmlns: 'urn:oasis:names:tc:opendocument:xmlns:container'
    }) do |container|
      container.rootfiles do |rootfiles|
        rootfiles.rootfile({
          'full-path' => package_file_path,
          'media-type' => 'application/oebps-package+xml'
        })
      end
    end
    doc.to_xml
  end

  def ncx_file_path
    "#{CONTAINER_DIRECTORY}/#{NCX_FILENAME}"
  end

  def ncx_file_contents
    @ncx.to_xml
  end

  # responsibility of minimizing number of files, naming files should be here?
  # except package file needs these names :-/
  def write filename
    Zip::OutputStream.open("#{filename}.#{FILENAME_EXTENSION}") do |stream|
      stream.put_next_entry(mimetype_file_path, nil, nil, Zip::Entry::STORED)
      stream.write(mimetype_file_contents)

      stream.put_next_entry(container_file_path, nil, nil, Zip::Entry::DEFLATED)
      stream.write(container_file_contents)

      stream.put_next_entry(package_file_path, nil, nil, Zip::Entry::DEFLATED)
      stream.write(package_file_contents)

      stream.put_next_entry(ncx_file_path, nil, nil, Zip::Entry::DEFLATED)
      stream.write(ncx_file_contents)

      @content_documents.each do |content_document, content_document_path|
        stream.put_next_entry("#{CONTAINER_DIRECTORY}/#{content_document_path}", nil, nil, Zip::Entry::DEFLATED)
        stream.write(content_document.to_xml)
      end
    end
  end
end
