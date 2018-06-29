require 'spec_helper'

describe "CollectionSpace" do

  describe "XML helper" do

    def doc(xml)
      Nokogiri::XML(xml.to_xml)
    end

    let(:xml) { Nokogiri::XML::Builder.new(:encoding => 'UTF-8') }

    it "can 'add' correctly" do
      CollectionSpace::XML.add(xml, 'foo', 'bar')
      expect(doc(xml).xpath('//foo').text).to eq('bar')
    end

    it "can 'add group' correctly" do
      key = 'accessionDate'
      elements = {
        "dateDisplayDate" => '01-01-2000',
        'dateLatestDay' => '10?',
      }
      CollectionSpace::XML.add_group(xml, key, elements)
      expect(doc(xml).xpath(
        '/accessionDateGroup/dateDisplayDate').text).to eq('01-01-2000')
      expect(doc(xml).xpath(
        '/accessionDateGroup/dateLatestDay').text).to eq('10?')
    end

  end

end
