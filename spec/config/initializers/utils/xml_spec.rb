require 'spec_helper'

describe "CollectionSpace" do

  describe "XML helper" do

    def doc(xml)
      Nokogiri::XML(xml.to_xml)
    end

    let(:xml) { Nokogiri::XML::Builder.new(:encoding => 'UTF-8') }

    it "can 'add' correctly" do
      CollectionSpace::XML.add(xml, 'foo', 'bar')
      expect(doc(xml).xpath('/foo').text).to eq('bar')
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

    it "can 'add group list' correctly" do
      source_data_date = '1971'
      structured_date  = CollectionSpace::DateParser.parse(source_data_date)
      key = 'objectProductionDate'
      elements = [
        {
          "scalarValuesComputed" => true,
          "dateEarliestSingleDay" => structured_date.earliest_day,
          "dateEarliestScalarValue" => structured_date.earliest_scalar,
          "dateLatestScalarValue" => structured_date.latest_scalar,
          "dateLatestDay" => structured_date.latest_day,
        },
        {
          "scalarValuesComputed" => false,
        }
      ]
      CollectionSpace::XML.add_group_list(xml, key, elements)

      expect(doc(xml).xpath(
        '/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/scalarValuesComputed').text).to eq('true')
      expect(doc(xml).xpath(
        '/objectProductionDateGroupList/objectProductionDateGroup[position()=2]/scalarValuesComputed').text).to eq('false')

      expect(doc(xml).xpath(
        '/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/dateEarliestScalarValue').text).to eq("1971-01-01 00:00:00 -0800")
      expect(doc(xml).xpath(
        '/objectProductionDateGroupList/objectProductionDateGroup[position()=1]/dateLatestScalarValue').text).to eq("1972-01-01 00:00:00 -0800")
    end

  end

end
