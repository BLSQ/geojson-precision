require "spec_helper"

RSpec.describe Geojson::Precision do
  it "has a version number" do
    expect(Geojson::Precision::VERSION).not_to be nil
  end

  let(:parser) { Geojson::Precision::Parser.new(3) }

  %w[Point
     Polygon
     HolyPolygon
     MultiPoint
     MultiPolygon
     MultiLineString
     FeatureCollection
     GeometryCollection
     FeatureCollectNoGeo
     InvalidObject].each do |feature|

    it "should map #{feature}" do
      feature_in = JSON.parse(fixture_content(:precision, "#{feature}.json"))
      feature_out = JSON.parse(fixture_content(:precision, "#{feature}_expected.json"))
      result = parser.parse(feature_in)
      puts "result #{feature}_expected.json: #{JSON.generate(result)}" if result != feature_out
      expect(result).to eq(feature_out)
    end
  end
end
