class Podcaster::Feed

  def initialize(channel_info={}, items=nil)
    @channel_info = channel_info
    @items        = items
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "version" => "2.0" do
        xml.channel do
          xml.title @channel_info.fetch(:title, '')
          xml.link @channel_info.fetch(:link, '')
          xml.language @channel_info.fetch(:language, 'en-us')
          xml.copyright "#{"&#x2117; &amp; &#xA9 #{Time.now.year}"} #{@channel_info.fetch(:copyright, '' )}"
          xml['itunes'].subtitle @channel_info.fetch(:subtitle, '')
          xml['itunes'].author @channel_info.fetch(:author, '')
          xml['itunes'].summary @channel_info.fetch(:description, '')
          xml.description @channel_info.fetch(:description, '')
          xml['itunes'].owner do
            xml['itunes'].name @channel_info.fetch(:name, '')
            xml['itunes'].email @channel_info.fetch(:email, '')
          end
          xml['itunes'].image :href => @channel_info.fetch(:image_url, '')
          xml['itunes'].category :text => @channel_info.fetch(:top_category, '') do
            if @channel_info[:sub_category].present?
              xml['itunes'].category :text => @channel_info[:sub_category]
            end
          end
          xml['itunes'].keywords @channel_info.fetch(:keywords, '')
          xml['itunes'].explicit @channel_info.fetch(:explicit, 'no')
          @items.each do |item|
            xml.item do
              xml.title item.title
              xml['itunes'].author item.author
              xml['itunes'].subtitle item.subtitle
              xml['itunes'].summary item.summary
              xml['itunes'].image :href => item.image_url
              xml.enclosure :url => item.file_url, :length => item.file_length, :type => item.file_type
              xml.guid item.file_url
              xml.pubDate item.pub_date
              xml['itunes'].duration item.duration
              xml.category @channel_info.fetch(:top_category, '')
              xml['itunes'].explicit @channel_info.fetch(:explicit, 'no')
              xml['itunes'].keywords @channel_info.fetch(:keywords, '')
            end
          end
        end
      end
    end

    builder.to_xml
  end

end
