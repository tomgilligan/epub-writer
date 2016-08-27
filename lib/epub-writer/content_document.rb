class EPUBWriter
  class ContentDocument
    MIME_TYPE = 'application/xhtml+xml'

    def initialize(epub)
      @epub = epub
      @stylesheets = []
    end

    def stylesheet(stylesheet_filename)
      @stylesheets.push(stylesheet_filename)
    end

    def to_xml
      doc = Nokogiri::XML::Builder.new({
        encoding: 'UTF-8'
      })

      doc.html({
        'xmlns:epub' => 'http://www.idpf.org/2007/ops'
      }) do |html|
        html.head do |head|
          head.title(@epub.title) if @epub.title

          #@stylesheets.each do |stylesheet|
            ## how is this going to work for multiple content documents?
            ## copy stylesheet to somewhere it will get picked up by subsequent zipping
            ## stylesheet must go in the manifest
            #head.link({
              #rel: 'stylesheet',
              #href: 'stylesheet.css',
              #type: 'text/css'
            #})
          #end

          head.meta({
            charset: 'utf-8'
          })
        end

        html.body do |body|
          #issue.to_doc(html)
        end
      end

      doc.to_xml
    end
  end
end
